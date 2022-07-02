//
//  YogiHomeCollectionViewCell.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

final class YogiHomeCollectionViewCell: UICollectionViewCell {
    let productImageView = YogiProductImageView(frame: .zero)
    private let rateStackView = YogiRateStackView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureYogiHomeCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(product: Product) {
        let d = try! Data(contentsOf: URL(string: product.thumbnailPath)!)
        let i = UIImage(data: d)
        productImageView.image = i
        rateStackView.setRateValue(rate: product.rate)
        configureFavoriteButton(isFavorite: product.isFavorite)
    }
    
    private func configureYogiHomeCollectionViewCell() {
        configureImageView()
        configureRateStackView()
    }
    
    private func configureImageView() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(120)
        }
    }
    
    private func configureRateStackView() {
        contentView.addSubview(rateStackView)
        rateStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).inset(-10)
            $0.leading.equalTo(productImageView.snp.leading)
        }
    }
    
    private func configureFavoriteButton(isFavorite: Bool) {
        if isFavorite == true {
            productImageView.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            productImageView.favoriteButton.tintColor = .systemRed
        } else  {
            productImageView.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            productImageView.favoriteButton.tintColor = .white
        }
    }
}
