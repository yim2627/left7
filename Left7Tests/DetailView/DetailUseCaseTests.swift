//
//  DetailUseCaseTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class DetailUseCaseTests: XCTestCase {
    func test_updateFavoriteProduct_whenIsFavoriteProduct() {
        let coreDataRepository = MockFavoriteProductRepository()
        
        let useCase = YogiDetailUseCase(favoriteProductRepository: coreDataRepository)
        
        let product = Product(
            id: -4,
            name: "",
            thumbnailPath: "",
            descriptionImagePath: "",
            descriptionSubject: "",
            price: -4,
            rate: -4,
            isFavorite: true
        )
        
        useCase.updateFavoriteProduct(product)
        coreDataRepository.verifySaveFavoriteProduct(product: product)
    }
    
    func test_updateFavoriteProduct_whenIsNotFavoriteProduct() {
        let coreDataRepository = MockFavoriteProductRepository()
        
        let useCase = YogiDetailUseCase(favoriteProductRepository: coreDataRepository)
        
        let product = Product(
            id: -4,
            name: "",
            thumbnailPath: "",
            descriptionImagePath: "",
            descriptionSubject: "",
            price: -4,
            rate: -4,
            isFavorite: false
        )
    
        useCase.updateFavoriteProduct(product)
        coreDataRepository.verifyDeleteFavoriteProduct(product: product)
    }
}
