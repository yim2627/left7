//
//  YogiProductImageView.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

import SnapKit

final class YogiProductImageView: UIImageView {
    let favoriteButton: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureUI() {
        configureImageView()
        configureFavoriteButtonLayout()
    }
    
    private func configureImageView() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = Design.yogiProductImageViewLayerCornerRadius
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    private func configureFavoriteButtonLayout() {
        self.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Design.favoriteButtonTopTrailingInset)
        }
    }
    
    func setFavoriteState(state: Bool) {
        favoriteButton.setImage(
            state ? UIImage(systemName: Design.favoriteButtonSystemImageNameWhenTrue) : UIImage(systemName: Design.favoriteButtonSystemImageNameWhenFalse),
            for: .normal
        )
        favoriteButton.tintColor = state ? .systemRed : .systemGray
    }
}

private extension YogiProductImageView {
    enum Design {
        static let yogiProductImageViewLayerCornerRadius = 8.0
        
        static let favoriteButtonTopTrailingInset = 10
        static let favoriteButtonSystemImageNameWhenTrue = "suit.heart.fill"
        static let favoriteButtonSystemImageNameWhenFalse = "suit.heart"
    }
}
