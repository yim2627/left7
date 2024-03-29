//
//  HomeViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import UIKit

import RxSwift
import RxCocoa
import RxDataSources

import ReactorKit

import SnapKit
import Swinject

final class HomeViewController: UIViewController, View {
	private typealias Section = RxCollectionViewSectionedReloadDataSource<HomeDataSection>
	
	//MARK: - Properties
	
	private lazy var homeCollectionView: UICollectionView = {
		let layout = configureHomeCollectionViewCompositionalLayout()
		let collectionView = UICollectionView(
			frame: .zero,
			collectionViewLayout: layout
		)
		
		return collectionView
	}()
	
	private lazy var dataSource: Section = {
		Section(configureCell: { [weak self] dataSource, collectionView, indexPath, movie in
			let cell = collectionView.dequeueReusableCell(
				withClass: HomeCollectionViewCell.self,
				indextPath: indexPath
			)

			let initialState = HomeCollectionViewCellReactor.State(movie: movie)
			let cellReactor = HomeCollectionViewCellReactor(state: initialState)

			cell.reactor = cellReactor

			self?.reactor.flatMap { reactor in // 옵셔널을 벗기기 위해 flatMap
				cell.favoriteButtonTap
					.map { _ in Reactor.Action.didTapFavoriteButton(indexPath.row) }
				// HomeViewController의 Reactor가 아닌 Cell의 Reactor로 액션을 보내서 Cell이 가진 Movie를 변경하고 favorite 상태에 따라 로컬 저장소를 업데이트 한뒤 Cell에서 reactor의 state를 구독하고 있으면 될듯
					.bind(to: reactor.action)
					.disposed(by: cell.disposeBag)
			}

			return cell
		})
	}()
	
	var disposeBag = DisposeBag()
	
	private let container: Container
	
	init(reactor: HomeViewReactor, container: Container) {
		defer {
			self.reactor = reactor
		}
		
		self.container = container
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//MARK: - View Life Cycle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tabBarController?.tabBar.isHidden = false
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configureHomeCollectionView()
	}
	
	//MARK: - Binding
	
	func bind(reactor: HomeViewReactor) {
		bindAction(reactor)
		bindState(reactor)
	}
	
	private func bindAction(_ reactor: HomeViewReactor) {
		self.rx.viewDidLoad
			.map { Reactor.Action.fetchMovies }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		self.rx.viewWillAppear
			.skip(1) // 뷰 최초 진입시 viewDidLoad에서 서버에서 내려오는 상품과 local에 저장되어 있는 상태를 비교하여 데이터를 내려주므로 찜한 상품을 또 받아올 필요가 없음
			.map { Reactor.Action.fetchFavoriteMovies }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		homeCollectionView.rx.contentOffset
			.skip(3)
			.withUnretained(self)
			.filter { (self, offset) in
				guard self.homeCollectionView.frame.height > 0 else {
					return false
				}
				
				// contentsize의 특정 경계점을 정해놓은 뒤 스크롤이 얼마나 됐는지의 수치인 offset을 기존 collectionView의 높이에 더해 경계점을 넘으면 이벤트를 보내 데이터를 추가적으로 받아오게 하였음
				return self.homeCollectionView.frame.height + offset.y >= self.homeCollectionView.contentSize.height - Design.collectioViewPaginationSpot
			}
			.map { _ in Reactor.Action.loadNextPage }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		homeCollectionView.rx.itemSelected
			.subscribe(onNext: { [unowned self, unowned reactor] indexPath in
				self.homeCollectionView.deselectItem(at: indexPath, animated: false)
				let detailReactor = DetailViewReactor(dependency: container.resolve(DetailViewReactorDependencyType.self)!, selectedMovie: reactor.currentState.movies[indexPath.row])
				
//				모듈화 관점으로 다시 생각
				// detailReactor를 HomeReactor에서 생성하여 내려줬다면 의존성이 더 떨어졌을 듯
				let detailViewController = DetailViewController(reactor: detailReactor)
				// 뷰컨이 다른 뷰컨을 알고 있는 것은 화면 전환 로직을 Coordinator로 분리하여 주었다면 의존성이 더 떨어졌을 듯
				// 하지만 Coordinator 패턴에 대해 공부하고 있던 터라 적용하기엔 이른 레벨이라고 생각하였다.
				
				self.navigationController?.pushViewController(detailViewController, animated: true)
			})
			.disposed(by: disposeBag)
	}
	
	private func bindState(_ reactor: HomeViewReactor) {
		reactor.state
			.map { [HomeDataSection(items: $0.movies)] }
			.bind(to: homeCollectionView.rx.items(dataSource: dataSource))
			.disposed(by: disposeBag)
	}
}

//MARK: - Configure CollectionView

private extension HomeViewController {
	func configureHomeCollectionView() {
		configureHomeCollectionViewCell()
		
		view.addSubview(homeCollectionView)
		configureHomeCollectionViewLayout()
	}
	
	func configureHomeCollectionViewLayout() {
		homeCollectionView.snp.makeConstraints {
			$0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
			$0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
			$0.leading.trailing.equalToSuperview()
		}
	}
	
	func configureHomeCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
		let sectionProvider = { [weak self] (sectionIndex: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			let section = self?.makeCollectionViewMovieSection()
			
			return section
		}
		return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
	}
	
	func makeCollectionViewMovieSection() -> NSCollectionLayoutSection? {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: Design.collectionViewCompositionalLayoutItemWidth,
			heightDimension: Design.collectionViewCompositionalLayoutItemHeight
		)
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		item.edgeSpacing = Design.collectionViewCompositionalLayoutItemEdgeSpacing
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: Design.collectionViewCompositionalLayoutGroupWidth,
			heightDimension: Design.collectionViewCompositionalLayoutGroupHeight
		)
		let group = NSCollectionLayoutGroup.horizontal(
			layoutSize: groupSize,
			subitems: [item]
		)
		group.interItemSpacing = Design.collectionViewCompositionalLayoutGroupInterItemSpacing
		
		let section = NSCollectionLayoutSection(group: group)
		
		return section
	}
	
	func configureHomeCollectionViewCell() {
		homeCollectionView.registerCell(withClass: HomeCollectionViewCell.self)
	}
}

//MARK: - Design

private extension HomeViewController {
	enum Design {
		static let collectionViewCompositionalLayoutItemWidth = NSCollectionLayoutDimension.fractionalWidth(0.45)
		static let collectionViewCompositionalLayoutItemHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
		static let collectionViewCompositionalLayoutItemEdgeSpacing = NSCollectionLayoutEdgeSpacing(
			leading: NSCollectionLayoutSpacing.fixed(11),
			top: nil,
			trailing: nil,
			bottom: nil
		)
		
		static let collectionViewCompositionalLayoutGroupWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
		static let collectionViewCompositionalLayoutGroupHeight = NSCollectionLayoutDimension.estimated(350)
		static let collectionViewCompositionalLayoutGroupInterItemSpacing = NSCollectionLayoutSpacing.fixed(5)
		
		static let collectioViewPaginationSpot = 100.0
	}
}
