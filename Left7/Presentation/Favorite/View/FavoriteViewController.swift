//
//  FavoriteViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import UIKit

import RxSwift
import RxCocoa

import ReactorKit

import SnapKit

final class FavoriteViewController: UIViewController, View {
    private enum FavoriteSection: Hashable {
        case favorite
    }
    
    private enum SortAlertActionType {
        case lastRegistered
        case rate
    }
    
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, Movie>
    
    //MARK: - Properties

    private lazy var favoriteMovieCollectionView: UICollectionView = {
        let layout = configureFavoritMovieeCollectionViewCompositionalLayout()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        return collectionView
    }()
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: Design.sortButtonSystemImageName), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private var dataSource: DiffableDataSource?
    
    var disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureFavoriteMovieCollectionView()
        configureNavigationBar()
    }
    
    //MARK: - Binding

    func bind(reactor: FavoriteViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: FavoriteViewReactor) {
        self.rx.viewWillAppear
            .map { Reactor.Action.fetchFavoriteMovies }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        favoriteMovieCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self, unowned reactor] indexPath in
                self.favoriteMovieCollectionView.deselectItem(at: indexPath, animated: false)
                let detailReactor = DetailViewReactor(selectedMovie: reactor.currentState.movies[indexPath.row])
                let detailViewController = DetailViewController()
                detailViewController.reactor = detailReactor
                
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        sortButton.rx.tap
            .flatMap { [unowned self] _ in
                self.showAlertController(
                    isSortOrderByLastRegistered: reactor.currentState.isSortOrderByLateRegistered, // 초기엔 정렬되있지 않으므로 기본값 False
                    isSortOrderByRate: reactor.currentState.isSortOrderByRate // 초기엔 정렬되있지 않으므로 기본값 False
                )
            }
            .map { action in
                switch action {
                case .lastRegistered:
                    return Reactor.Action.didTapSortOrderByLastRegisteredAction
                case .rate:
                    return Reactor.Action.didTapSortOrderByRateAction
                }
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: FavoriteViewReactor) {
        reactor.state
            .map { $0.movies }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] movies in
                self?.applySnapShot(movies: movies)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlertController(
        isSortOrderByLastRegistered: Bool,
        isSortOrderByRate: Bool
    ) -> Observable<SortAlertActionType> {
        let orderByLastRegisteredActionTitle = isSortOrderByLastRegistered ? "오래된등록순" : "최근등록순"
        let orderByRateActionTitle = isSortOrderByRate ? "평점낮은순" : "평점높은순"
        
        return Observable.create { emmiter in
            let alertController = UIAlertController(
                title: nil,
                message: nil,
                preferredStyle: .actionSheet
            )
            
            let orderByLastRegisteredAction = UIAlertAction(
                title: orderByLastRegisteredActionTitle,
                style: .default
            ) { _ in
                emmiter.onNext(.lastRegistered)
                emmiter.onCompleted()
            }
            
            let orderByRateAction = UIAlertAction(
                title: orderByRateActionTitle,
                style: .default
            ) { _ in
                emmiter.onNext(.rate)
                emmiter.onCompleted()
            }
            
            let cancelAction = UIAlertAction(
                title: Design.cancelActionTitle,
                style: .cancel
            )
            
            alertController.addAction(orderByLastRegisteredAction)
            alertController.addAction(orderByRateAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
    }
    
    //MARK: - CollectionView SnapShot
    
    private func applySnapShot(movies: [Movie]) {
        var snapShot = NSDiffableDataSourceSnapshot<FavoriteSection, Movie>()
        
        snapShot.appendSections([.favorite])
        snapShot.appendItems(movies, toSection: .favorite)
        
        dataSource?.apply(snapShot)
    }
}

//MARK: - Configure NavigationBar

private extension FavoriteViewController {
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
}

//MARK: - Configure CollectionView

private extension FavoriteViewController {
    func configureFavoriteMovieCollectionView() {
        configureFavoriteMovieCollectionViewCell()
        
        view.addSubview(favoriteMovieCollectionView)
        configureFavoriteMovieCollectionViewLayout()
        configureFavoriteMovieCollectionviewDataSource()
    }
    
    func configureFavoriteMovieCollectionViewLayout() {
        favoriteMovieCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureFavoritMovieeCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self?.makeCollectionViewFavoriteMovieSection()
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func makeCollectionViewFavoriteMovieSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: Design.collectionViewCompositionalLayoutItemWidth,
            heightDimension: Design.collectionViewCompositionalLayoutItemHeight
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: Design.collectionViewCompositionalLayoutGroupWidth,
            heightDimension: Design.collectionViewCompositionalLayoutGroupHeight
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func configureFavoriteMovieCollectionViewCell() {
        favoriteMovieCollectionView.registerCell(withClass: FavoriteCollectionViewCell.self)
    }
    
    func configureFavoriteMovieCollectionviewDataSource() {
        dataSource = DiffableDataSource(collectionView: favoriteMovieCollectionView) { [unowned self]
            (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) in
            let cell = collectionView.dequeueReusableCell(
                withClass: FavoriteCollectionViewCell.self,
                indextPath: indexPath
            )
            
            let initialState = FavoriteCollectionViewCellReactor.State(movie: movie)
            let cellReactor = FavoriteCollectionViewCellReactor(state: initialState)
            
            cell.reactor = cellReactor
            
            reactor.flatMap { reactor in
                cell.favoriteButtonTap
                    .map { Reactor.Action.didTapFavoriteButton(movie) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
            
            return cell
        }
    }
}

//MARK: - Design

private extension FavoriteViewController {
    enum Design {
        static let sortButtonSystemImageName = "arrow.up.arrow.down.circle"
        
        static let cancelActionTitle = "취소"
        
        static let collectionViewCompositionalLayoutItemWidth = NSCollectionLayoutDimension.fractionalWidth(1)
        static let collectionViewCompositionalLayoutItemHeight = NSCollectionLayoutDimension.fractionalHeight(1)
        
        static let collectionViewCompositionalLayoutGroupWidth = NSCollectionLayoutDimension.fractionalWidth(1)
        static let collectionViewCompositionalLayoutGroupHeight = NSCollectionLayoutDimension.absolute(250)
    }
}
