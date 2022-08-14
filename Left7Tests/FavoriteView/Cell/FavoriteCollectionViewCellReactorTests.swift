//
//  FavoriteCollectionViewCellReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class FavoriteCollectionViewCellReactorTests: XCTestCase {
    func test_initReactor_with_movie() {
        let testMovie: Movie = .empty
        
        let initialState = FavoriteCollectionViewCellReactor.State(movie: testMovie)
        let reactor = FavoriteCollectionViewCellReactor(state: initialState)
        
        XCTAssertEqual(reactor.currentState.movie, testMovie)
    }
}
