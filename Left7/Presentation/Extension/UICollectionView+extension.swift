//
//  UICollectionView+extension.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(
        withClass: T.Type,
        indextPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indextPath
        ) as? T else {
            return T()
        }
        
        return cell
    }
    
    func registerCell<T: UICollectionViewCell>(withClass: T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: String(describing: T.self))
    }
}
