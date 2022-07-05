//
//  YogiFavoriteViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import UIKit

import SnapKit

final class YogiFavoriteViewController: UIViewController {
    private var yogiFavoriteCollectionView: UICollectionView!
    
    private enum FavoriteSection: Hashable {
        case favorite
    }

    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<FavoriteSection, Product>
    private var dataSource: DiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYogiFavoriteCollectionView()
    }
    
    private func configureYogiFavoriteCollectionView() {
        let layout = configureYogiFavoriteCollectionViewCompositionalLayout()
        yogiFavoriteCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        configureYogiFavoriteCollectionViewCell()
        
        view.addSubview(yogiFavoriteCollectionView)
        configureYogiFavoriteCollectionViewLayout()
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
}
