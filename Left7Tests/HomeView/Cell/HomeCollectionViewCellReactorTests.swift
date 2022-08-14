//
//  HomeCollectionViewCellReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class HomeCollectionViewCellReactorTests: XCTestCase {
    func test_initReactor_with_movie() {
        let testMovie: Movie = .empty
        
        let initialState = HomeCollectionViewCellReactor.State(movie: testMovie)
        let reactor = HomeCollectionViewCellReactor(state: initialState)
        
        XCTAssertEqual(reactor.currentState.movie, testMovie)
    }
}
