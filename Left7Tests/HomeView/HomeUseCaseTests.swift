//
//  HomeUseCaseTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

class HomeUseCaseTests: XCTestCase {
    private var testProducts: [Product]!
    private var testFavoriteProducts: [Product]!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        testProducts = [
            Product(
                id: -1,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: false
            ),
            Product(
                id: -2,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -2,
                rate: -2,
                isFavorite: false
            ),
            Product(
                id: -3,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -3,
                rate: -3,
                isFavorite: false
            )
        ]
        
        testFavoriteProducts = [
            Product(
                id: -1,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: true
            ),
            Product(
                id: -3,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -3,
                rate: -3,
                isFavorite: true
            )
        ]
        
        disposeBag = DisposeBag()
    }
    
    func test_fetchProducts() {
        let networkRepository = MockProductRepository(data: testProducts)
        let coreDataRepository = MockFavoriteProductRepository(data: testFavoriteProducts)
        
        let useCase = YogiHomeUseCase(
            productRepository: networkRepository,
            favoriteProductRepository: coreDataRepository
        )
        
        let page = 1
        
        useCase.fetchProducts(page: page)
            .subscribe(onNext: { products in
                XCTAssertEqual(!self.testProducts[0].isFavorite, products[0].isFavorite)
                XCTAssertEqual(!self.testProducts[2].isFavorite, products[2].isFavorite)
                networkRepository.verifyFetchYogiProducts(page: page)
            })
            .disposed(by: disposeBag)
    }
    
    func test_fetchFavoriteProduct() {
        let networkRepository = MockProductRepository(data: testProducts)
        let coreDataRepository = MockFavoriteProductRepository(data: testFavoriteProducts)
        
        let useCase = YogiHomeUseCase(
            productRepository: networkRepository,
            favoriteProductRepository: coreDataRepository
        )
        
        useCase.fetchFavoriteProduct()
            .subscribe(onNext: { favoriteProducts in
                XCTAssertEqual(self.testFavoriteProducts, favoriteProducts)
                coreDataRepository.verifyFetchFavoriteProduct()
            })
            .disposed(by: disposeBag)
    }
    
    func test_updateFavoriteProduct_whenIsFavoriteProduct() {
        let networkRepository = MockProductRepository(data: testProducts)
        let coreDataRepository = MockFavoriteProductRepository(data: testFavoriteProducts)
        
        let useCase = YogiHomeUseCase(
            productRepository: networkRepository,
            favoriteProductRepository: coreDataRepository
        )
        
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
        let networkRepository = MockProductRepository(data: testProducts)
        let coreDataRepository = MockFavoriteProductRepository(data: testFavoriteProducts)
        
        let useCase = YogiHomeUseCase(
            productRepository: networkRepository,
            favoriteProductRepository: coreDataRepository
        )
        
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



