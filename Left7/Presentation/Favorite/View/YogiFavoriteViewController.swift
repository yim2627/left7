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
        
        applySnapShot(products: [
            Product(id: 1001, name: "내 집 같은 편안한 여기어때 숙소", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_1.jpg", descriptionImagePath: "https://gccompany.co.kr/App/image/img_1.jpg", descriptionSubject: "합리적인 가격으로 안심, 청결, 내 집 같은 편암함을 제공합니다.", price: 30000, rate: 9.9, isFavorite: true, favoriteRegistrationTime: Date()),
            Product(id: 1005, name: "따뜻한 분위기의 서비스와 현대적인 호텔", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_2.jpg", descriptionImagePath: "https://gccompany.co.kr/App/image/img_2.jpg", descriptionSubject: "따뜻한 분위기의 서비스와 현대적인 호텔에서의 편안한 숙박이 되시길 바랍니다.", price: 15000, rate: 9.8, isFavorite: false, favoriteRegistrationTime: Date()),
            Product(id: 1010, name: "여기어때 남산", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_3.jpg", descriptionImagePath: "https://gccompany.co.kr/App/image/img_3.jpg", descriptionSubject: "남산은 서울특별시 중구와 용산구에 걸쳐있는 산이다. 높이는 해발 270.85m로서 서울의 중심부에 위치하여 서울의 상징이 되기도 한다. 정상에는 N서울타워가 있으며, 그 부근까지는 케이블카가 설치되어 있으며, 남산 1·2·3호 터널이 뚫려 있다.", price: 25000, rate: 9.6, isFavorite: false, favoriteRegistrationTime: Date()),
            Product(id: 1233, name: "가나다라마바사아자차카타파하파타카차자아사바마라다나가", thumbnailPath: "https://gccompany.co.kr/App/thumbnail/thumb_img_5.jpg", descriptionImagePath: "https://gccompany.co.kr/App/image/img_5.jpg", descriptionSubject: "도보 이용 부탁합니다.", price: 30000, rate:  9.2, isFavorite: true, favoriteRegistrationTime: Date())
        ])
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
        dataSource = DiffableDataSource(collectionView: yogiFavoriteCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, product: Product) in
            let cell = collectionView.dequeueReusableCell(
                withClass: YogiFavoriteCollectionViewCell.self,
                indextPath: indexPath
            )
            
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
