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
    //MARK: - Properties

    private let productDetailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        
        return scrollView
    }()
    
    private let productDetailStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Design.productDetailStackViewLayoutMargin
        stackView.axis = .vertical
        stackView.spacing = Design.productDetailStackViewSpacing
        
        return stackView
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        
        return imageView
    }()
    
    private let productNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.productNameLabelNumberOfLine
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
        label.numberOfLines = Design.productSubjectLabelNumberOfLine
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .black
        
        return label
    }()
    
    private let seperateLineView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.borderWidth = Design.seperateLineViewLayerBorderWidth
        view.layer.borderColor = UIColor.lightGray.cgColor
        
        return view
    }()
    
    private let favoriteButton = UIButton()
    
    var disposeBag = DisposeBag()
    
    //MARK: - View Life Cycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureYogiProductDetailView()
        configureNavigationBar()
    }
    
    //MARK: - Binding

    func bind(reactor: YogiDetailViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: YogiDetailViewReactor) {
        favoriteButton.rx.tap
            .map { _ in Reactor.Action.didTapFavoriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: YogiDetailViewReactor) {
        reactor.state
            .compactMap { $0.product }
            .asDriver(onErrorJustReturn: .empty)
            .drive(onNext: { [weak self] in
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
}

//MARK: - Set Data

private extension YogiDetailViewController {
    func setData(product: Product) {
        productImageView.setImage(with: product.descriptionImagePath)
        productNameLabel.text = product.name
        productRateStackView.setRateValue(rate: product.rate)
        
        let productPrice = YogiNumberFormatter.shared.toString(number: product.price)
        productPriceLabel.text = "\(productPrice) 원"
        
        productSubjectLabel.text = product.descriptionSubject
        setFavoriteState(state: product.isFavorite)
    }
    
    func setFavoriteState(state: Bool) {
        favoriteButton.setImage(
            state ? UIImage(systemName: Design.favoriteButtonSystemImageNameWhenTrue) : UIImage(systemName: Design.favoriteButtonSystemImageNameWhenFalse),
            for: .normal
        )
        favoriteButton.tintColor = state ? .systemRed : .systemGray
    }
}

//MARK: - Configure NavigationBar

private extension YogiDetailViewController {
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = String()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
}

//MARK: - Configure View

private extension YogiDetailViewController {
    func configureYogiProductDetailView() {
        configureProductDetailScrollView()
        configureProductDetailStackView()
    }
    
    func configureProductDetailScrollView() {
        view.addSubview(productDetailScrollView)
        productDetailScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        productDetailScrollView.addSubview(productImageView)
        productImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Design.productImageViewHeight)
        }
        
        productDetailScrollView.addSubview(productDetailStackView)
        productDetailStackView.snp.makeConstraints {
            $0.top.equalTo(productImageView.snp.bottom).offset(Design.productDetailStackViewTopMargin)
            $0.leading.trailing.bottom.equalTo(productDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(productDetailScrollView.frameLayoutGuide)
        }
    }
    
    func configureProductDetailStackView() {
        productDetailStackView.addArrangedSubview(productNameLabel)
        productDetailStackView.addArrangedSubview(productRateStackView)
        productDetailStackView.addArrangedSubview(productPriceLabel)
        
        productDetailStackView.addArrangedSubview(seperateLineView)
        seperateLineView.snp.makeConstraints {
            $0.height.equalTo(Design.seperateLineViewHeight)
        }
        
        productDetailStackView.addArrangedSubview(productSubjectLabel)
    }
}

//MARK: - Design

private extension YogiDetailViewController {
    enum Design {
        static let productDetailStackViewLayoutMargin = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 10
        )
        static let productDetailStackViewSpacing = 12.0
        static let productDetailStackViewTopMargin = 10
        
        static let productNameLabelNumberOfLine = 0
        
        static let productSubjectLabelNumberOfLine = 0
        
        static let seperateLineViewLayerBorderWidth = 1.0
        static let seperateLineViewHeight = 1
        
        static let productImageViewHeight = 300
        
        static let favoriteButtonSystemImageNameWhenTrue = "suit.heart.fill"
        static let favoriteButtonSystemImageNameWhenFalse = "suit.heart"
    }
}
