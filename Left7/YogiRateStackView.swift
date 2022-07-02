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
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = .systemYellow
        return imageView
    }()
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
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
        self.spacing = 4
        
        self.addArrangedSubview(starImageView)
        self.addArrangedSubview(rateLabel)
    }
    
    func setRateValue(rate: Double) {
        rateLabel.text = "\(rate)"
    }
}
