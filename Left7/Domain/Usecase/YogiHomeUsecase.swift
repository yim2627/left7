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
    private let favoriteProductRepository: CoreDataRepository
    
    init(
        productRepository: NetworkRepository = YogiProductRepository(),
        favoriteProductRepository: CoreDataRepository = YogiFavoriteProductRepository()
    ) {
        self.productRepository = productRepository
        self.favoriteProductRepository = favoriteProductRepository
    }
    
    func fetchProducts(page: Int) -> Observable<[Product]> {
        productRepository.fetchYogiProducts(page: page)
    }
}
