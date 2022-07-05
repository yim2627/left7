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

final class YogiFavoriteCollectionViewCell: UICollectionViewCell {
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 16
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let productRateStackView = YogiRateStackView(frame: .zero)
    
    private let productFavoriteLableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .trailing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let productFavoriteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기 등록 시간"
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
    
    private func configureYogiFavoriteCollectionViewCell() {
        configureProductImageView()
        configureProductFavoriteLableStackView()
        configureProductInformationStackView()
    }
    
    private func configureProductImageView() {
        self.contentView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20)
            $0.width.equalTo(150)
            $0.height.equalTo(200)
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
            $0.leading.equalTo(productImageView.snp.trailing).inset(-25)
            $0.trailing.equalToSuperview().inset(25)
        }
        
        self.productInformationStackView.addArrangedSubview(productNameLabel)
        self.productInformationStackView.addArrangedSubview(productRateStackView)
        self.productInformationStackView.addArrangedSubview(productFavoriteLableStackView)
    }
    
    func setData(product: Product) {
        productNameLabel.text = product.name
        productImageView.setImage(with: product.thumbnailPath)
        productImageView.setFavoriteState(state: product.isFavorite)
        productRateStackView.setRateValue(rate: product.rate)
        productFavoriteRegistrationTimeLabel.text = YogiDateFormatter.shared.toDateString(date: product.favoriteRegistrationTime ?? Date())
    }
}
