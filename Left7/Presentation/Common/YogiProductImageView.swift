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
        configureAblyGoodsImageView()
        configureFavoriteButtonLayout()
    }
    
    private func configureAblyGoodsImageView() {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 8
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    private func configureFavoriteButtonLayout() {
        self.addSubview(favoriteButton)
        favoriteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(10)
        }
    }
    
    func setFavoriteState(state: Bool) {
        if state == true {
            self.favoriteButton.setImage(UIImage(systemName: "suit.heart.fill"), for: .normal)
            self.favoriteButton.tintColor = .systemRed
        } else  {
            self.favoriteButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
            self.favoriteButton.tintColor = .white
        }
    }
}
