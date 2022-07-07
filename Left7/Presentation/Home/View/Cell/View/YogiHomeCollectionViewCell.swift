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

import ReactorKit

final class YogiHomeCollectionViewCell: UICollectionViewCell, View {
    private let productImageView = YogiProductImageView(frame: .zero)
    private let productRateStackView = YogiRateStackView(frame: .zero)
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.productNameLabelNumberOfLine
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
    
    func bind(reactor: YogiHomeCollectionViewCellReactor) {
        guard let currentProduct = reactor.currentState.product else {
            return
        }
        
        productImageView.setImage(with: currentProduct.thumbnailPath)
        productRateStackView.setRateValue(rate: currentProduct.rate)
        configureFavoriteButton(isFavorite: currentProduct.isFavorite)
        productNameLabel.text = currentProduct.name
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
            $0.height.equalTo(Design.productImageViewHeight)
        }
    }
    
    private func configureRateStackView() {
        contentView.addSubview(productRateStackView)
        productRateStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(Design.productRateStackViewTopInset)
            $0.leading.equalTo(productImageView.snp.leading)
            $0.trailing.equalTo(productImageView.snp.trailing)
        }
    }
    
    private func configureProductNameLabel() {
        contentView.addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints {
            $0.top.equalTo(productRateStackView.snp.bottom).offset(Design.productNameLabelTopInset)
            $0.leading.equalTo(productRateStackView.snp.leading)
            $0.trailing.equalTo(productRateStackView.snp.trailing)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureFavoriteButton(isFavorite: Bool) {
        productImageView.setFavoriteState(state: isFavorite)
    }
}

private extension YogiHomeCollectionViewCell {
    enum Design {
        static let productNameLabelNumberOfLine = 2
        static let productNameLabelTopMargin = 8
        
        static let productImageViewHeight = 120
        
        static let productRateStackViewTopMargin = 8
    }
}
