//
//  ViewController.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import UIKit

import RxSwift
import RxCocoa

import ReactorKit

import SnapKit

final class YogiHomeViewController: UIViewController {
    private var yogiHomeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureYogiHomeCollectionView()
    }
    
    func configureYogiHomeCollectionView() {
        yogiHomeCollectionView = UICollectionView() // Layout 추가
        
        view.addSubview(yogiHomeCollectionView)
        configureYogiHomeCollectionViewLayout()
        yogiHomeCollectionView.backgroundColor = .blue // 임시 체크
    }
    
    func configureYogiHomeCollectionViewLayout() {
        yogiHomeCollectionView.snp.makeConstraints { [weak self] in
            guard let self = self else {
                return
            }
            
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

