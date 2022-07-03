//
//  YogiDetailViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import UIKit

import SnapKit

final class YogiDetailViewController: UIViewController {
    private let productDetailScrollView = UIScrollView(frame: .zero)
    
    private let productDetailStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.backgroundColor = .white
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let productImageView: YogiProductImageView = {
        let imageView = YogiProductImageView(frame: .zero)
        imageView.setImage(with: "https://gccompany.co.kr/App/image/img_1.jpg")
        imageView.clipsToBounds = false 
        imageView.setFavoriteState(state: true)
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자호텔야자"
        label.textColor = .black
        return label
    }()
    
    private let rateStackView = YogiRateStackView(frame: .zero)
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .right
        label.text = "30000원"
        label.textColor = .black
        return label
    }()
    
    private let productSubjectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때올여름혼자어때"
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYogiProductDetailView()
    }
    
    private func configureYogiProductDetailView() {
        configureProductDetailScrollView()
        configureProductDetailStackView()
    }
    
    private func configureProductDetailScrollView() {
        self.view.addSubview(productDetailScrollView)
        productDetailScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureProductDetailStackView() {
        self.productDetailScrollView.addSubview(productDetailStackView)
        productDetailStackView.snp.makeConstraints {
            $0.edges.equalTo(productDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(productDetailScrollView.frameLayoutGuide)
        }
        
        self.productDetailStackView.addArrangedSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.height.equalTo(300)
        }
        
        self.productDetailStackView.addArrangedSubview(productNameLabel)
        self.productDetailStackView.addArrangedSubview(rateStackView)
        self.productDetailStackView.addArrangedSubview(productPriceLabel)
        self.productDetailStackView.addArrangedSubview(productSubjectLabel)
    }
}
