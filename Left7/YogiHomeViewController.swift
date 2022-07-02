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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureYogiHomeCollectionView()
    }
    
    func configureYogiHomeCollectionView() {
        let layout = configureYogiCollectionViewCompositionalLayout()
        yogiHomeCollectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        
        view.addSubview(yogiHomeCollectionView)
        configureYogiHomeCollectionViewLayout()
        yogiHomeCollectionView.backgroundColor = .blue // 임시 체크
    }
    
    func configureYogiHomeCollectionViewLayout() {
        yogiHomeCollectionView.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    func configureYogiCollectionViewCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { [weak self] (sectionIndex: Int, enviroment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self?.makeCollectionViewYogiProductSection()
            
            return section
        }
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func makeCollectionViewYogiProductSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(500)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        
        return section
    }
}

