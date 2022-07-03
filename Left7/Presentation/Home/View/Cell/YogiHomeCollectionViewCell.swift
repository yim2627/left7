//
//  YogiHomeCollectionViewCell.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

final class YogiHomeCollectionViewCell: UICollectionViewCell {
    private let productImageView = YogiProductImageView(frame: .zero)
    private let rateStackView = YogiRateStackView(frame: .zero)
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        return label
    }()
    
    var favoriteButtonTap: Observable<Void> {
        return self.productImageView.favoriteButton.rx.tap.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureYogiHomeCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(product: Product) {
        productImageView.setImage(with: product.thumbnailPath)
        rateStackView.setRateValue(rate: product.rate)
        configureFavoriteButton(isFavorite: product.isFavorite)
        productNameLabel.text = product.name
    }
    
    private func configureYogiHomeCollectionViewCell() {
        configureImageView()
        configureRateStackView()
        configureProductNameLabel()
    }
    
    private func configureImageView() {
        contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(120)
        }
    }
    
    private func configureRateStackView() {
        contentView.addSubview(rateStackView)
        rateStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).inset(-8)
            $0.leading.equalTo(productImageView.snp.leading)
            $0.trailing.equalTo(productImageView.snp.trailing)
        }
    }
    
    private func configureProductNameLabel() {
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(rateStackView.snp.bottom).inset(-8)
            $0.leading.equalTo(rateStackView.snp.leading)
            $0.trailing.equalTo(rateStackView.snp.trailing)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureFavoriteButton(isFavorite: Bool) {
        productImageView.setFavoriteState(state: isFavorite)
    }
}
