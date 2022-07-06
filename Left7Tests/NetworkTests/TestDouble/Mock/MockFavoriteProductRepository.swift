//
//  MockFavoriteProductRepository.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class MockFavoriteProductRepository: CoreDataRepository {
    private var data: [Product]
    
    private var saveFavoriteProduct: Product?
    private var deleteFavoriteProduct: Product?
    private var fetchFavoriteProductCallCount: Int = 0
    private var saveFavoriteProductCallCount: Int = 0
    private var deleteFavoriteProductCallCount: Int = 0
    
    init(data: [Product]) {
        self.data = data
    }
    
    func fetchFavoriteProduct() -> Observable<[Product]> {
        self.fetchFavoriteProductCallCount += 1
        
        return Observable.just(data)
    }
    
    func saveFavoriteProduct(_ product: Product) {
        self.saveFavoriteProduct = product
        self.saveFavoriteProductCallCount += 1
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        self.deleteFavoriteProduct = product
        self.deleteFavoriteProductCallCount += 1
    }
    
    func verifyFetchFavoriteProduct(callCount: Int = 1) {
        XCTAssertEqual(self.fetchFavoriteProductCallCount, callCount)
    }
    
    func verifySaveFavoriteProduct(product: Product, callCount: Int = 1) {
        XCTAssertEqual(self.saveFavoriteProduct, product)
        XCTAssertEqual(self.saveFavoriteProductCallCount, callCount)
    }
    
    func verifyDeleteFavoriteProduct(product: Product, callCount: Int = 1) {
        XCTAssertEqual(self.deleteFavoriteProduct, product)
        XCTAssertEqual(self.deleteFavoriteProductCallCount, callCount)
    }
}

