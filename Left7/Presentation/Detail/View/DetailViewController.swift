//
//  DetailViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import UIKit

import RxSwift
import RxCocoa

import ReactorKit

import SnapKit

final class DetailViewController: UIViewController, View {
    //MARK: - Properties

    private let movieDetailScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        
        return scrollView
    }()
    
    private let movieDetailStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = Design.movieDetailStackViewLayoutMargin
        stackView.axis = .vertical
        stackView.spacing = Design.movieDetailStackViewSpacing
        
        return stackView
    }()
    
    private let movieImageView = UIImageView(frame: .zero)
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.movieNameLabelNumberOfLine
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .black
        
        return label
    }()
    
    private let movieRateStackView = MovieRateStackView(frame: .zero)
    
    private let moviePriceLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textAlignment = .right
        label.textColor = .black
        
        return label
    }()
    
    private let movieDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.movieDescriptionLabelNumberOfLine
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
        configureMovieDetailView()
        configureNavigationBar()
    }
    
    //MARK: - Binding

    func bind(reactor: DetailViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func bindAction(_ reactor: DetailViewReactor) {
        favoriteButton.rx.tap
            .map { _ in Reactor.Action.didTapFavoriteButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DetailViewReactor) {
        reactor.state
            .compactMap { $0.movie }
            .asDriver(onErrorJustReturn: .empty)
            .drive(onNext: { [weak self] in
                self?.setData(movie: $0)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.movie?.isFavorite }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] in
                self?.setFavoriteState(state: $0)
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Set Data

private extension DetailViewController {
    func setData(movie: Movie) {
        movieImageView.setImage(with: movie.posterPath)
        movieNameLabel.text = movie.name
        movieRateStackView.setRateValue(rate: movie.rate)
        
        moviePriceLabel.text = ""
        
        movieDescriptionLabel.text = movie.descriptionSubject
        setFavoriteState(state: movie.isFavorite)
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

private extension DetailViewController {
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = String()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
}

//MARK: - Configure View

private extension DetailViewController {
    func configureMovieDetailView() {
        configureMovieDetailScrollView()
        configureMovieDetailStackView()
    }
    
    func configureMovieDetailScrollView() {
        view.addSubview(movieDetailScrollView)
        movieDetailScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        movieDetailScrollView.addSubview(movieImageView)
        movieImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Design.movieImageViewHeight)
        }
        
        movieDetailScrollView.addSubview(movieDetailStackView)
        movieDetailStackView.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(Design.movieDetailStackViewTopMargin)
            $0.leading.trailing.bottom.equalTo(movieDetailScrollView.contentLayoutGuide)
            $0.width.equalTo(movieDetailScrollView.frameLayoutGuide)
        }
    }
    
    func configureMovieDetailStackView() {
        movieDetailStackView.addArrangedSubview(movieNameLabel)
        movieDetailStackView.addArrangedSubview(movieRateStackView)
        movieDetailStackView.addArrangedSubview(moviePriceLabel)
        
        movieDetailStackView.addArrangedSubview(seperateLineView)
        seperateLineView.snp.makeConstraints {
            $0.height.equalTo(Design.seperateLineViewHeight)
        }
        
        movieDetailStackView.addArrangedSubview(movieDescriptionLabel)
    }
}

//MARK: - Design

private extension DetailViewController {
    enum Design {
        static let movieDetailStackViewLayoutMargin = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 10
        )
        static let movieDetailStackViewSpacing = 12.0
        static let movieDetailStackViewTopMargin = 10
        
        static let movieNameLabelNumberOfLine = 0
        
        static let movieDescriptionLabelNumberOfLine = 0
        
        static let seperateLineViewLayerBorderWidth = 1.0
        static let seperateLineViewHeight = 1
        
        static let movieImageViewHeight = 300
        
        static let favoriteButtonSystemImageNameWhenTrue = "suit.heart.fill"
        static let favoriteButtonSystemImageNameWhenFalse = "suit.heart"
    }
}
