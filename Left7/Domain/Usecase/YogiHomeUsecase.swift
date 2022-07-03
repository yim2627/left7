//
//  YogiHomeUsecase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation
import RxSwift

final class YogiHomeUsecase {
    private let productRepository: NetworkRepository
    
    init(productRepository: NetworkRepository = YogiProductRepository()) {
        self.productRepository = productRepository
    }
    
    func fetchProducts(page: Int) -> Observable<[Product]> {
        productRepository.fetchYogiProducts(page: page)
    }
}
