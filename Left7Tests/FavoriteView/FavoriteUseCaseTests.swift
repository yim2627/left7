//
//  FavoriteUseCaseTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

class FavoriteUseCaseTests: XCTestCase {
    private var testFavoriteProducts: [Product]!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
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
    
    func test_fetchFavoriteProducts() {
        let coreDataRepository = MockFavoriteProductRepository(data: testFavoriteProducts)
        
        let useCase = YogiFavoriteUsecase(favoriteProductRepository: coreDataRepository)
        
        useCase.fetchFavoriteProduct()
            .subscribe(onNext: { favoriteProducts in
                XCTAssertEqual(self.testFavoriteProducts, favoriteProducts)
                coreDataRepository.verifyFetchFavoriteProduct()
            })
            .disposed(by: disposeBag)
    }
}
