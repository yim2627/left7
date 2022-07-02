//
//  YogiHomeCollectionViewCell.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

class YogiHomeCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
