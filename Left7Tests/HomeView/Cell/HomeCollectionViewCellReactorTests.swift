//
//  HomeCollectionViewCellReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class HomeCollectionViewCellReactorTests: XCTestCase {
    func test_initReactor_with_product() {
        let testProduct: Product = .empty
        
        let initialState = YogiHomeCollectionViewCellReactor.State(product: testProduct)
        let reactor = YogiHomeCollectionViewCellReactor(state: initialState)
        
        XCTAssertEqual(reactor.currentState.product, testProduct) 
    }
}
