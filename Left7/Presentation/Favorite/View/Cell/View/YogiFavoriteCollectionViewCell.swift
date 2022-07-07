//
//  YogiFavoriteCollectionViewCell.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

import ReactorKit

final class YogiFavoriteCollectionViewCell: UICollectionViewCell, View {
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = Design.productInformationStackViewSpacing
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.productNameLabelNumberOfLine
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let productRateStackView = YogiRateStackView(frame: .zero)
    
    private let productFavoriteLableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Design.productFavoriteLableStackViewSpacing
        stackView.alignment = .trailing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let productFavoriteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Design.productFavoriteTitleLabelText
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .lightGray
        return label
    }()
    
    private let productFavoriteRegistrationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .lightGray
        return label
    }()
    
    private let productImageView = YogiProductImageView(frame: .zero)
    
    var favoriteButtonTap: Observable<Void> {
        return self.productImageView.favoriteButton.rx.tap.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureYogiFavoriteCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: YogiFavoriteCollectionViewCellReactor) {
        guard let currentProduct = reactor.initialState.product else {
            return
        }
        
        productNameLabel.text = currentProduct.name
        productImageView.setImage(with: currentProduct.thumbnailPath)
        productImageView.setFavoriteState(state: currentProduct.isFavorite)
        productRateStackView.setRateValue(rate: currentProduct.rate)
        productFavoriteRegistrationTimeLabel.text = YogiDateFormatter.shared.toDateString(date: currentProduct.favoriteRegistrationTime ?? Date())
    }
    
    private func configureYogiFavoriteCollectionViewCell() {
        configureProductImageView()
        configureProductFavoriteLableStackView()
        configureProductInformationStackView()
    }
    
    private func configureProductImageView() {
        self.contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(Design.productImageViewLeadingTopInset)
            $0.width.equalTo(Design.productImageViewWidth)
            $0.height.equalTo(Design.productImageViewHeight)
        }
    }
    
    private func configureProductFavoriteLableStackView() {
        self.productFavoriteLableStackView.addArrangedSubview(productFavoriteTitleLabel)
        self.productFavoriteLableStackView.addArrangedSubview(productFavoriteRegistrationTimeLabel)
    }
    
    private func configureProductInformationStackView() {
        self.contentView.addSubview(productInformationStackView)
        productInformationStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.top)
            $0.leading.equalTo(productImageView.snp.trailing).offset(Design.productInformationStackViewLeadingMargin)
            $0.trailing.equalToSuperview().inset(Design.productInformationStackViewTrailingInset)
        }
        
        self.productInformationStackView.addArrangedSubview(productNameLabel)
        self.productInformationStackView.addArrangedSubview(productRateStackView)
        self.productInformationStackView.addArrangedSubview(productFavoriteLableStackView)
    }
}

private extension YogiFavoriteCollectionViewCell {
    enum Design {
        static let productInformationStackViewSpacing = 16.0
        static let productInformationStackViewLeadingMargin = 25
        static let productInformationStackViewTrailingInset = 25
        
        static let productNameLabelNumberOfLine = 0
        
        static let productFavoriteLableStackViewSpacing = 4.0
        
        static let productFavoriteTitleLabelText = "즐겨찾기 등록 시간"
        
        static let productImageViewWidth = 150
        static let productImageViewHeight = 200
        static let productImageViewLeadingTopInset = 20
    }
}
