//
//  YogiFavoriteViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import UIKit

import RxSwift
import RxCocoa

import ReactorKit

import SnapKit

final class YogiFavoriteViewController: UIViewController, View {
    private var yogiFavoriteCollectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
    private enum FavoriteSection: Hashable {
        case favorite
    }

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, Product>
    private var dataSource: DiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYogiFavoriteCollectionView()
        self.reactor = YogiFavoriteViewReactor()
    }
    
    func bind(reactor: YogiFavoriteViewReactor) {
        self.rx.viewWillAppear
            .map { Reactor.Action.fetchFavoriteProducts }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        yogiFavoriteCollectionView.rx.itemSelected
            .subscribe(onNext: { [unowned self, unowned reactor] indexPath in
                self.yogiFavoriteCollectionView.deselectItem(at: indexPath, animated: false)
                let detailReactor = YogiDetailViewReactor(selectedProduct: reactor.currentState.products[indexPath.row])
                let detailViewController = YogiDetailViewController()
                detailViewController.reactor = detailReactor
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.products }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] products in
                self?.applySnapShot(products: products)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureYogiFavoriteCollectionView() {
        let layout = configureYogiFavoriteCollectionViewCompositionalLayout()
        yogiFavoriteCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        configureYogiFavoriteCollectionViewCell()
        
        view.addSubview(yogiFavoriteCollectionView)
        configureYogiFavoriteCollectionViewLayout()
        configureYogiFavoriteCollectionviewDataSource()
    }
    
    private func configureYogiFavoriteCollectionViewLayout() {
        yogiFavoriteCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureYogiFavoriteCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self?.makeCollectionViewYogiFavoriteProductSection()
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func makeCollectionViewYogiFavoriteProductSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureYogiFavoriteCollectionViewCell() {
        yogiFavoriteCollectionView.registerCell(withClass: YogiFavoriteCollectionViewCell.self)
    }
    
    private func configureYogiFavoriteCollectionviewDataSource() {
        dataSource = DiffableDataSource(collectionView: yogiFavoriteCollectionView) { [unowned self]
            (collectionView: UICollectionView, indexPath: IndexPath, product: Product) in
            let cell = collectionView.dequeueReusableCell(
                withClass: YogiFavoriteCollectionViewCell.self,
                indextPath: indexPath
            )
            
            cell.favoriteButtonTap
                .map { Reactor.Action.didTapFavoriteButton(product) }
                .bind(to: self.reactor!.action)
                .disposed(by: cell.disposeBag)
            
            cell.setData(product: product)
            
            return cell
        }
    }
    
    private func applySnapShot(products: [Product]) {
        var snapShot = NSDiffableDataSourceSnapshot<FavoriteSection, Product>()
        
        snapShot.appendSections([.favorite])
        snapShot.appendItems(products, toSection: .favorite)
        
        dataSource?.apply(snapShot)
    }
}
