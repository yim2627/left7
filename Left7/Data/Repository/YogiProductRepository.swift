//
//  YogiHomeRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import Foundation
import RxSwift

final class YogiProductRepository: NetworkRepository {
    func fetchYogiProduct() -> Observable<Product> {
        return .empty()
    }
}
