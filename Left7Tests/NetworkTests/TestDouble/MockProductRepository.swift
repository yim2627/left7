//
//  MockProductRepository.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class MockProductRepository: NetworkRepository {
    private var data: [Product]
    
    private var page: Int?
    private var callCount: Int = 0
    
    init(data: [Product]) {
        self.data = data
    }
    
    func fetchYogiProducts(page: Int) -> Observable<[Product]> {
        self.page = page
        self.callCount += 1
        
        return Observable.just(data)
    }
    
    func verifyFetchYogiProducts(page: Int, callCount: Int = 1) {
        XCTAssertEqual(self.page, page)
        XCTAssertEqual(self.callCount, callCount)
    }
}
