//
//  YogiDetailUsecase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

final class YogiDetailUsecase {
    private let favoriteProductRepository: CoreDataRepository
    
    init(favoriteProductRepository: CoreDataRepository = YogiFavoriteProductRepository()) {
        self.favoriteProductRepository = favoriteProductRepository
    }
    
    func saveFavoriteProduct(_ product: Product) {
        favoriteProductRepository.saveFavoriteProduct(product)
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        favoriteProductRepository.deleteFavoriteProduct(product)
    }
}
