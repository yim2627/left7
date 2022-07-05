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

class YogiFavoriteCollectionViewCell: UICollectionViewCell {
    private let productInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()
    
    private let productRateStackView = YogiRateStackView(frame: .zero)
    
    private let productFavoriteLableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .trailing
        stackView.axis = .vertical
        return stackView
    }()
    
    private let productFavoriteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기 등록 시간"
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .lightGray
        return label
    }()
    
    private let productFavoriteRegistrationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
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
            $0.trailing.equalTo(productInformationStackView.snp.leading).inset(20)
            $0.height.equalTo(200)
        }
    }
    
    private func configureProductFavoriteLableStackView() {
        self.productFavoriteLableStackView.addSubview(productFavoriteTitleLabel)
        self.productFavoriteLableStackView.addSubview(productFavoriteLableStackView)
    }
    
    private func configureProductInformationStackView() {
        self.contentView.addSubview(productInformationStackView)
        productInformationStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.top)
            $0.bottom.equalTo(productImageView.snp.bottom)
            $0.trailing.equalToSuperview().inset(10)
        }
        
        self.productInformationStackView.addArrangedSubview(productNameLabel)
        self.productInformationStackView.addArrangedSubview(productRateStackView)
        self.productInformationStackView.addArrangedSubview(productFavoriteLableStackView)
    }
}
