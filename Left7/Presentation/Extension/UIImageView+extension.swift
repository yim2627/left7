//
//  UIImageView+extension.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import UIKit

import Kingfisher

extension UIImageView {
    func setImage(with urlString: String) {
        let cache = ImageCache.default
        let url = "https://image.tmdb.org/t/p/w300" + urlString + "?api_key=13002531cbc59fc376da2b25a2fb918a"
        print(url)
        cache.retrieveImage(forKey: url, options: nil) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self.image = image
                } else {
                    guard let url = URL(string: url) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
