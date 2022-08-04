//
//  ViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import UIKit

import RxSwift
import RxCocoa

import ReactorKit

import SnapKit

final class YogiHomeViewController: UIViewController, View {
    private enum HomeSection: Hashable {
        case home
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<HomeSection, Product>
    
    //MARK: - Properties

    private lazy var yogiHomeCollectionView: UICollectionView = {
        let layout = configureYogiHomeCollectionViewCompositionalLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        return collectionView
    }()
    
    private var dataSource: DiffableDataSource? // 기존 스냅샷과 새로운 스냅샷을 비교하여 다른 상태값만 업데이트해주므로 reloadData보다 비교적으로 성능이 우수하다.
    
    var disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureYogiHomeCollectionView()
    }
    
    //MARK: - Binding
    
    func bind(reactor: YogiHomeViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: YogiHomeViewReactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.fetchProducts }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .skip(1) // 뷰 최초 진입시 viewDidLoad에서 서버에서 내려오는 상품과 local에 저장되어 있는 상태를 비교하여 데이터를 내려주므로 찜한 상품을 또 받아올 필요가 없음
            .map { Reactor.Action.fetchFavoriteProducts }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yogiHomeCollectionView.rx.contentOffset
            .withUnretained(self)
            .filter { (self, offset) in
                guard self.yogiHomeCollectionView.frame.height > 0 else {
                    return false
                }
                
                // contentsize의 특정 경계점을 정해놓은 뒤 스크롤이 얼마나 됐는지의 수치인 offset을 기존 collectionView의 높이에 더해 경계점을 넘으면 이벤트를 보내 데이터를 추가적으로 받아오게 하였음
                return self.yogiHomeCollectionView.frame.height + offset.y <= self.yogiHomeCollectionView.contentSize.height - Design.collectioViewPaginationSpot
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yogiHomeCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self, unowned reactor] indexPath in
                self.yogiHomeCollectionView.deselectItem(at: indexPath, animated: false)
                let detailReactor = YogiDetailViewReactor(selectedProduct: reactor.currentState.products[indexPath.row])
                // detailReactor를 HomeReactor에서 생성하여 내려줬다면 의존성이 더 떨어졌을 듯
                let detailViewController = YogiDetailViewController()
                // 뷰컨이 다른 뷰컨을 알고 있는 것은 화면 전환 로직을 Coordinator로 분리하여 주었다면 의존성이 더 떨어졌을 듯
                // 하지만 Coordinator 패턴에 대해 공부하고 있던 터라 적용하기엔 이른 레벨이라고 생각하였다.
                detailViewController.reactor = detailReactor
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: YogiHomeViewReactor) {
        reactor.state
            .map { $0.products }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] products in
                self?.applySnapShot(products: products)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - CollectionView SnapShot

    private func applySnapShot(products: [Product]) {
        var snapShot = NSDiffableDataSourceSnapshot<HomeSection, Product>()
        
        snapShot.appendSections([.home])
        snapShot.appendItems(products, toSection: .home)
        
        dataSource?.apply(snapShot)
    }
}

//MARK: - Configure CollectionView

private extension YogiHomeViewController {
    func configureYogiHomeCollectionView() {
        configureYogiHomeCollectionViewCell()
        
        view.addSubview(yogiHomeCollectionView)
        configureYogiHomeCollectionViewLayout()
        configureYogiHomeCollectionviewDataSource()
    }
    
    func configureYogiHomeCollectionViewLayout() {
        yogiHomeCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureYogiHomeCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self?.makeCollectionViewYogiProductSection()
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func makeCollectionViewYogiProductSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: Design.collectionViewCompositionalLayoutItemWidth,
            heightDimension: Design.collectionViewCompositionalLayoutItemHeight
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = Design.collectionViewCompositionalLayoutItemContensInset
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: Design.collectionViewCompositionalLayoutGroupWidth,
            heightDimension: Design.collectionViewCompositionalLayoutGroupHeight
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = Design.collectionViewCompositionalLayoutGroupContensInset
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureYogiHomeCollectionViewCell() {
        yogiHomeCollectionView.registerCell(withClass: YogiHomeCollectionViewCell.self)
    }
    
    func configureYogiHomeCollectionviewDataSource() {
        dataSource = DiffableDataSource(collectionView: yogiHomeCollectionView) { [unowned self]
            (collectionView: UICollectionView, indexPath: IndexPath, product: Product) in
            let cell = collectionView.dequeueReusableCell(
                withClass: YogiHomeCollectionViewCell.self,
                indextPath: indexPath
            )
            
            let initialState = YogiHomeCollectionViewCellReactor.State(product: product)
            let cellReactor = YogiHomeCollectionViewCellReactor(state: initialState)
            
            cell.reactor = cellReactor
            
            reactor.flatMap { reactor in // 옵셔널을 벗기기 위해 flatMap
                cell.favoriteButtonTap
                    .map { _ in Reactor.Action.didTapFavoriteButton(indexPath.row) }
//                    .map {
//                        YogiHomeCollectionViewCellReactor.Action.dd
//                    }
                    // HomeViewController의 Reactor가 아닌 Cell의 Reactor로 액션을 보내서 Cell이 가진 Product를 변경하고 favorite 상태에 따라 로컬 저장소를 업데이트 한뒤 Cell에서 reactor의 state를 구독하고 있으면 될듯
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            
            return cell
        }
    }
}

//MARK: - Design

private extension YogiHomeViewController {
    enum Design {
        static let collectionViewCompositionalLayoutItemWidth = NSCollectionLayoutDimension.fractionalWidth(0.5)
        static let collectionViewCompositionalLayoutItemHeight = NSCollectionLayoutDimension.fractionalHeight(1.0)
        static let collectionViewCompositionalLayoutItemContensInset = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 0
        )
        
        static let collectionViewCompositionalLayoutGroupWidth = NSCollectionLayoutDimension.fractionalWidth(1.0)
        static let collectionViewCompositionalLayoutGroupHeight = NSCollectionLayoutDimension.absolute(250.0)
        static let collectionViewCompositionalLayoutGroupContensInset = NSDirectionalEdgeInsets(
            top: 16,
            leading: 0,
            bottom: 0,
            trailing: 16
        )
        
        static let collectioViewPaginationSpot = 100.0
    }
}
