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
            .skip(1)
            .map { Reactor.Action.fetchFavoriteProducts }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yogiHomeCollectionView.rx.contentOffset
            .withUnretained(self)
            .filter { (self, offset) in
                guard self.yogiHomeCollectionView.frame.height > 0 else {
                    return false
                }
                
                return self.yogiHomeCollectionView.frame.height + offset.y <= self.yogiHomeCollectionView.contentSize.height - Design.collectioViewPaginationSpot
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yogiHomeCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self, unowned reactor] indexPath in
                self.yogiHomeCollectionView.deselectItem(at: indexPath, animated: false)
                let detailReactor = YogiDetailViewReactor(selectedProduct: reactor.currentState.products[indexPath.row])
                let detailViewController = YogiDetailViewController()
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
            
            reactor.flatMap { reactor in
                cell.favoriteButtonTap
                    .map { _ in Reactor.Action.didTapFavoriteButton(indexPath.row) }
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
