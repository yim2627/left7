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
    private var yogiHomeCollectionView: UICollectionView!
    var disposeBag = DisposeBag()
    
    private enum HomeSection: Hashable {
        case home
    }

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<HomeSection, Product>
    private var dataSource: DiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYogiHomeCollectionView()
        self.reactor = YogiHomeViewReactor()
    }
    
    func bind(reactor: YogiHomeViewReactor) {
        self.rx.viewWillAppear
            .take(1)
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
                
                return self.yogiHomeCollectionView.frame.height + offset.y >= self.yogiHomeCollectionView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.products }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] products in
                self?.applySnapShot(products: products)
            })
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
    
    private func configureYogiHomeCollectionView() {
        let layout = configureYogiHomeCollectionViewCompositionalLayout()
        yogiHomeCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        configureYogiHomeCollectionViewCell()
        
        view.addSubview(yogiHomeCollectionView)
        configureYogiHomeCollectionViewLayout()
        configureYogiHomeCollectionviewDataSource()
    }
    
    private func configureYogiHomeCollectionViewLayout() {
        yogiHomeCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureYogiHomeCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self?.makeCollectionViewYogiProductSection()
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    private func makeCollectionViewYogiProductSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        group.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureYogiHomeCollectionViewCell() {
        yogiHomeCollectionView.registerCell(withClass: YogiHomeCollectionViewCell.self)
    }
    
    private func configureYogiHomeCollectionviewDataSource() {
        dataSource = DiffableDataSource(collectionView: yogiHomeCollectionView) { [unowned self]
            (collectionView: UICollectionView, indexPath: IndexPath, product: Product) in
            let cell = collectionView.dequeueReusableCell(
                withClass: YogiHomeCollectionViewCell.self,
                indextPath: indexPath
            )
            
            cell.favoriteButtonTap
                .map { _ in Reactor.Action.didTapFavoriteButton(indexPath.row) }
                .bind(to: self.reactor!.action)
                .disposed(by: cell.disposeBag)
            
            cell.setData(product: product)
            return cell
        }
    }
    
    private func applySnapShot(products: [Product]) {
        var snapShot = NSDiffableDataSourceSnapshot<HomeSection, Product>()
        
        snapShot.appendSections([.home])
        snapShot.appendItems(products, toSection: .home)
        
        dataSource?.apply(snapShot)
    }
}
