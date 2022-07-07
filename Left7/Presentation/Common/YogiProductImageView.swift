//
//  YogiProductImageView.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

import SnapKit

final class YogiProductImageView: UIImageView {
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

private extension YogiProductImageView {
    func configureUI() {
        configureImageView()
        configureFavoriteButtonLayout()
    }
    
    func configureImageView() {
        isUserInteractionEnabled = true
        layer.cornerRadius = Design.yogiProductImageViewLayerCornerRadius
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

private extension YogiProductImageView {
    enum Design {
        static let yogiProductImageViewLayerCornerRadius = 8.0
        
        static let favoriteButtonTopTrailingInset = 10
        static let favoriteButtonSystemImageNameWhenTrue = "suit.heart.fill"
        static let favoriteButtonSystemImageNameWhenFalse = "suit.heart"
    }
}
