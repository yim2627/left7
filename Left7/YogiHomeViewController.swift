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

final class YogiHomeViewController: UIViewController {
    private var yogiHomeCollectionView: UICollectionView!
    
    private enum HomeSection: Hashable {
        case home
    }

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<HomeSection, Product>
    private var dataSource: DiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureYogiHomeCollectionView()
        
        let products = [Product(id: 1, name: "1", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_1.jpg", descriptionImagePath: "1", descriptionSubject: "1", price: 1, rate: 0.1, isFavorite: true, favoriteRegistrationTime: Date()), Product(id: 2, name: "1", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_7.jpg", descriptionImagePath: "1", descriptionSubject: "1", price: 1, rate: 0.1, isFavorite: true, favoriteRegistrationTime: Date()), Product(id: 3, name: "1", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_6.jpg", descriptionImagePath: "1", descriptionSubject: "1", price: 1, rate: 0.1, isFavorite: true, favoriteRegistrationTime: Date()), Product(id: 4, name: "1", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_10.jpg", descriptionImagePath: "1", descriptionSubject: "1", price: 1, rate: 0.1, isFavorite: true, favoriteRegistrationTime: Date())]
        applySnapShot(products: products)
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
        yogiHomeCollectionView.backgroundColor = .blue // 임시 체크
        configureYogiHomeCollectionviewDataSource()
    }
    
    private func configureYogiHomeCollectionViewLayout() {
        yogiHomeCollectionView.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func configureYogiHomeCollectionViewCell() {
        yogiHomeCollectionView.registerCell(withClass: YogiHomeCollectionViewCell.self)
    }
    
    private func configureYogiHomeCollectionviewDataSource() {
        dataSource = DiffableDataSource(collectionView: yogiHomeCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, product: Product) in
            let cell = collectionView.dequeueReusableCell(
                withClass: YogiHomeCollectionViewCell.self,
                indextPath: indexPath
            )
            
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
