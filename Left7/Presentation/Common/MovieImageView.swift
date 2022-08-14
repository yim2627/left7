//
//  MovieImageView.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

import SnapKit

final class MovieImageView: UIImageView {
    //MARK: - Properties

    let favoriteButton: UIButton = UIButton()
    
    //MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Set Data

    func setFavoriteState(state: Bool) {
        favoriteButton.setImage(
            state ? UIImage(systemName: Design.favoriteButtonSystemImageNameWhenTrue) : UIImage(systemName: Design.favoriteButtonSystemImageNameWhenFalse),
            for: .normal
        )
        favoriteButton.tintColor = state ? .systemRed : .systemGray
    }
}

//MARK: - Configure View

private extension MovieImageView {
    func configureUI() {
        configureImageView()
        configureFavoriteButtonLayout()
    }
    
    func configureImageView() {
        isUserInteractionEnabled = true
        layer.cornerRadius = Design.movieImageViewLayerCornerRadius
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
    
    func configureFavoriteButtonLayout() {
        addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Design.favoriteButtonTopTrailingInset)
        }
    }
}

//MARK: - Design

private extension MovieImageView {
    enum Design {
        static let movieImageViewLayerCornerRadius = 8.0
        
        static let favoriteButtonTopTrailingInset = 10
        static let favoriteButtonSystemImageNameWhenTrue = "suit.heart.fill"
        static let favoriteButtonSystemImageNameWhenFalse = "suit.heart"
    }
}
