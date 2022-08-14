//
//  MockMovieRepository.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class MockMovieRepository: NetworkRepository {
    private var data: [Movie]
    
    private var page: Int?
    private var callCount: Int = 0
    
    init(data: [Movie]) {
        self.data = data
    }
    
    func fetchMovies(page: Int) -> Observable<[Movie]> {
        self.page = page
        self.callCount += 1
        
        return Observable.just(data)
    }
    
    func verifyFetchMovies(page: Int, callCount: Int = 1) {
        XCTAssertEqual(self.page, page)
        XCTAssertEqual(self.callCount, callCount)
    }
}
