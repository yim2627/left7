//
//  YogiDetailUsecase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

final class YogiDetailUseCase: YogiDetailUseCaseType {
    //MARK: - Properties

    private let favoriteProductRepository: CoreDataRepository
    
    //MARK: - Init

    init(favoriteProductRepository: CoreDataRepository = YogiFavoriteProductRepository()) {
        self.favoriteProductRepository = favoriteProductRepository
    }
    
    //MARK: - Method

    func updateFavoriteProduct(_ product: Product?) {
        guard let product = product else {
            return
        }
        
        if product.isFavorite {
            favoriteProductRepository.saveFavoriteProduct(product)
        } else {
            favoriteProductRepository.deleteFavoriteProduct(product)
        }
    }
}
