//
//  YogiDetailViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import UIKit

import RxSwift
import RxCocoa

import ReactorKit

import SnapKit


final class YogiDetailViewController: UIViewController, View {
    private let productDetailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private let productDetailStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .black
        return label
    }()
    
    private let productRateStackView = YogiRateStackView(frame: .zero)
    
    private let productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    private let productSubjectLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .black
        return label
    }()
    
    private let seperateLineView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let favoriteButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureYogiProductDetailView()
        configureNavigationBar()
    }
    
    func bind(reactor: YogiDetailViewReactor) {
        favoriteButton.rx.tap
            .map { _ in Reactor.Action.didTapFavoriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.product }
            .subscribe(onNext: { [weak self] in
                self?.setData(product: $0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.product?.isFavorite }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] in
                self?.setFavoriteState(state: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = String()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
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
        
        self.productDetailScrollView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(300)
        }
        
        self.productDetailScrollView.addSubview(productDetailStackView)
        productDetailStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalTo(productDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(productDetailScrollView.frameLayoutGuide)
        }
    }
    
    private func configureProductDetailStackView() {
        self.productDetailStackView.addArrangedSubview(productNameLabel)
        self.productDetailStackView.addArrangedSubview(productRateStackView)
        self.productDetailStackView.addArrangedSubview(productPriceLabel)
        
        self.productDetailStackView.addArrangedSubview(seperateLineView)
        seperateLineView.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        
        self.productDetailStackView.addArrangedSubview(productSubjectLabel)
    }
    
    private func setData(product: Product) {
        productImageView.setImage(with: product.descriptionImagePath)
        productNameLabel.text = product.name
        productRateStackView.setRateValue(rate: product.rate)
        productPriceLabel.text = "\(product.price)원"
        productSubjectLabel.text = product.descriptionSubject
        setFavoriteState(state: product.isFavorite)
    }
    
    private func setFavoriteState(state: Bool) {
        if state == true {
            self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            self.favoriteButton.tintColor = .systemRed
        } else  {
            self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            self.favoriteButton.tintColor = .lightGray
        }
    }
}
