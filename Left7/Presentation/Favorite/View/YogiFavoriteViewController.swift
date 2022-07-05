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
    
    private enum SortAlertActionType {
        case lastRegistered
        case rate
    }

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, Product>
    private var dataSource: DiffableDataSource?
    
    private let sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.up.arrow.down.circle"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureYogiFavoriteCollectionView()
        configureNavigationBar()
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
        
        sortButton.rx.tap
            .flatMap { [unowned self] _ in
                self.showAlertController()
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
        
        reactor.state
            .map { $0.products }
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] products in
                self?.applySnapShot(products: products)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sortButton)
    }
    
    private func showAlertController() -> Observable<SortAlertActionType> {
        return Observable.create { emmiter in
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let orderByLastRegisteredAction = UIAlertAction(title: "최근등록순", style: .default) { _ in
                emmiter.onNext(.lastRegistered)
                emmiter.onCompleted()
            }
            
            let orderByRateAction = UIAlertAction(title: "평점순", style: .default) { _ in
                emmiter.onNext(.rate)
                emmiter.onCompleted()
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            
            alertController.addAction(orderByLastRegisteredAction)
            alertController.addAction(orderByRateAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
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
