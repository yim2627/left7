//
//  DetailViewReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

import RxSwift

final class DetailViewReactorTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag()
    var reactor: DetailViewReactor!
    
    func test_didTapFavoriteButton() {
        let useCase = StubDetailUseCase()
        reactor = DetailViewReactor(useCase: useCase, selectedMovie: .empty) // isFavorite: False
        
        reactor.action.onNext(.didTapFavoriteButton)
        
        XCTAssertEqual(reactor.currentState.movie?.isFavorite, true)
        
        reactor.action.onNext(.didTapFavoriteButton)
        
        XCTAssertEqual(reactor.currentState.movie?.isFavorite, false)
    }
    
    func test_didTapFavoriteButton_with_abnormal_movie() {
        let useCase = StubDetailUseCase()
        reactor = DetailViewReactor(useCase: useCase, selectedMovie: nil)
        
        reactor.action.onNext(.didTapFavoriteButton)
        
        XCTAssertEqual(reactor.currentState.movie, .empty)
    }
}
