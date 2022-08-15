//
//  HomeCollectionViewCell.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

import ReactorKit

final class HomeCollectionViewCell: UICollectionViewCell, View {
    //MARK: - Properties

    private let movieImageView = MovieImageView(frame: .zero)
    private let movieRateStackView = MovieRateStackView(frame: .zero)
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.movieNameLabelNumberOfLine
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        
        return label
    }()
    
    var favoriteButtonTap: Observable<Void> {
        return movieImageView.favoriteButton.rx.tap.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - Init

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHomeCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Binding

    func bind(reactor: HomeCollectionViewCellReactor) {
        guard let currentMovie = reactor.currentState.movie else {
            return
        }
        
        movieImageView.setImage(with: currentMovie.posterPath)
        movieRateStackView.setRateValue(rate: currentMovie.rate)
        configureFavoriteButton(isFavorite: currentMovie.isFavorite)
        movieNameLabel.text = currentMovie.name
    }
}

//MARK: - Configure CollectionViewCell

private extension HomeCollectionViewCell {
    func configureHomeCollectionViewCell() {
        configureImageView()
        configureRateStackView()
        configureNameLabel()
    }
    
    func configureImageView() {
        contentView.addSubview(movieImageView)
        movieImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Design.movieImageViewHeight)
        }
    }
    
    func configureRateStackView() {
        contentView.addSubview(movieRateStackView)
        movieRateStackView.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(Design.movieRateStackViewTopMargin)
            $0.leading.equalTo(movieImageView.snp.leading)
            $0.trailing.equalTo(movieImageView.snp.trailing)
        }
    }
    
    func configureNameLabel() {
        contentView.addSubview(movieNameLabel)
        movieNameLabel.snp.makeConstraints {
            $0.top.equalTo(movieRateStackView.snp.bottom).offset(Design.movieNameLabelTopMargin)
            $0.leading.equalTo(movieRateStackView.snp.leading)
            $0.trailing.equalTo(movieRateStackView.snp.trailing)
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    func configureFavoriteButton(isFavorite: Bool) {
        movieImageView.setFavoriteState(state: isFavorite)
    }
}

//MARK: - Design

private extension HomeCollectionViewCell {
    enum Design {
        static let movieNameLabelNumberOfLine = 2
        static let movieNameLabelTopMargin = 8
        
        static let movieImageViewHeight = 250
        
        static let movieRateStackViewTopMargin = 8
    }
}
