//
//  YogiDetailViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import UIKit

import SnapKit

final class YogiDetailViewController: UIViewController {
    private let productImageView: YogiProductImageView = {
        let imageView = YogiProductImageView(frame: .zero)
        imageView.setImage(with: "https://gccompany.co.kr/App/image/img_1.jpg")
        imageView.clipsToBounds = false
        imageView.setFavoriteState(state: true)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(productImageView)
        
        productImageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(240)
        }
    }
}
