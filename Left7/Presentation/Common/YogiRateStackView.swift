//
//  YogiRateStackView.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

import SnapKit

final class YogiRateStackView: UIStackView {
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Design.starImageViewSystemImageName)
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureYogiRateStackView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureYogiRateStackView() {
        self.axis = .horizontal
        self.spacing = Design.yogiRateStackViewSpacing
        
        self.addArrangedSubview(starImageView)
        self.addArrangedSubview(rateLabel)
        
        starImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func setRateValue(rate: Double) {
        rateLabel.text = "\(rate)"
    }
}

private extension YogiRateStackView {
    enum Design {
        static let starImageViewSystemImageName = "star.fill"
        
        static let yogiRateStackViewSpacing = 4.0
    }
}
