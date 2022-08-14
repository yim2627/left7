//
//  FavoriteCollectionViewCell.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import UIKit

import SnapKit

import RxSwift
import RxCocoa

import ReactorKit

final class FavoriteCollectionViewCell: UICollectionViewCell, View {
    //MARK: - Properties

    private let movieInformationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = Design.movieInformationStackViewSpacing
        
        return stackView
    }()
    
    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = Design.movieNameLabelNumberOfLine
        label.textAlignment = .right
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .black
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        return label
    }()
    
    private let movieRateStackView = MovieRateStackView(frame: .zero)
    
    private let movieFavoriteLableStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = Design.movieFavoriteLableStackViewSpacing
        stackView.alignment = .trailing
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let movieFavoriteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = Design.movieFavoriteTitleLabelText
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let movieFavoriteRegistrationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .lightGray
        
        return label
    }()
    
    private let movieImageView = MovieImageView(frame: .zero)
    
    var favoriteButtonTap: Observable<Void> {
        return self.movieImageView.favoriteButton.rx.tap.asObservable()
    }
    
    var disposeBag = DisposeBag()
    
    //MARK: - Init

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureFavoriteCollectionViewCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Binding

    func bind(reactor: FavoriteCollectionViewCellReactor) {
        guard let currentMovie = reactor.initialState.movie else {
            return
        }
        
        movieNameLabel.text = currentMovie.name
        movieImageView.setImage(with: currentMovie.posterPath)
        movieImageView.setFavoriteState(state: currentMovie.isFavorite)
        movieRateStackView.setRateValue(rate: currentMovie.rate)
        movieFavoriteRegistrationTimeLabel.text = Left7DateFormatter.shared.toDateString(date: currentMovie.favoriteRegistrationTime ?? Date())
    }
}

//MARK: - Configure CollectionViewCell

private extension FavoriteCollectionViewCell {
    func configureFavoriteCollectionViewCell() {
        configureMovieImageView()
        configureMovieFavoriteLableStackView()
        configureMovieInformationStackView()
    }
    
    func configureMovieImageView() {
        contentView.addSubview(movieImageView)
        movieImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(Design.movieImageViewLeadingTopInset)
            $0.width.equalTo(Design.movieImageViewWidth)
            $0.height.equalTo(Design.movieImageViewHeight)
        }
    }
    
    func configureMovieFavoriteLableStackView() {
        movieFavoriteLableStackView.addArrangedSubview(movieFavoriteTitleLabel)
        movieFavoriteLableStackView.addArrangedSubview(movieFavoriteRegistrationTimeLabel)
    }
    
    func configureMovieInformationStackView() {
        contentView.addSubview(movieInformationStackView)
        movieInformationStackView.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.top)
            $0.leading.equalTo(movieImageView.snp.trailing).offset(Design.movieInformationStackViewLeadingMargin)
            $0.trailing.equalToSuperview().inset(Design.movieInformationStackViewTrailingInset)
        }
        
        movieInformationStackView.addArrangedSubview(movieNameLabel)
        movieInformationStackView.addArrangedSubview(movieRateStackView)
        movieInformationStackView.addArrangedSubview(movieFavoriteLableStackView)
    }
}

//MARK: - Design

private extension FavoriteCollectionViewCell {
    enum Design {
        static let movieInformationStackViewSpacing = 16.0
        static let movieInformationStackViewLeadingMargin = 25
        static let movieInformationStackViewTrailingInset = 25
        
        static let movieNameLabelNumberOfLine = 0
        
        static let movieFavoriteLableStackViewSpacing = 4.0
        
        static let movieFavoriteTitleLabelText = "즐겨찾기 등록 시간"
        
        static let movieImageViewWidth = 150
        static let movieImageViewHeight = 200
        static let movieImageViewLeadingTopInset = 20
    }
}
