//
//  FavoriteViewReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

import RxSwift

final class FavoriteViewReactorTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag()
    var reactor: FavoriteViewReactor!
    
    func test_fetchFavoriteMovies() {
        let useCase = StubFavoriteUseCase()
        reactor = FavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.movies.isEmpty, true)
        
        reactor.action.onNext(.fetchFavoriteMovies)
        
        reactor.state
            .map { $0.movies }
            .subscribe(onNext: {
                XCTAssertEqual($0.count, 3)
                XCTAssertEqual($0[0].isFavorite, true)
                XCTAssertEqual($0[1].isFavorite, true)
                XCTAssertEqual($0[2].isFavorite, true)
            })
            .disposed(by: disposeBag)
    }
    
    func test_didTapFavoriteButton() {
        let useCase = StubFavoriteUseCase()
        reactor = FavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.movies.isEmpty, true)
        
        // 기존 프로젝트 isFavorite toggle 확인을 위해 미리 프로젝트 세팅
        reactor.action.onNext(.fetchFavoriteMovies)
        
        XCTAssertEqual(reactor.currentState.movies.count, 3)
        
        let defaultMovie: Movie = .empty
        
        reactor.action.onNext(.didTapFavoriteButton(defaultMovie))
        
        reactor.state
            .map { $0.movies }
            .subscribe(onNext: {
                XCTAssertEqual($0.map { $0.id }.contains(defaultMovie.id), false)
            })
            .disposed(by: disposeBag)
    }
    
    func test_didTapSortOrderByLastRegisteredAction() {
        let useCase = StubFavoriteUseCase()
        reactor = FavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.movies.isEmpty, true)
        
        // 기존 Movie 정렬을 위해 미리 Movie 세팅
        reactor.action.onNext(.fetchFavoriteMovies)
        
        XCTAssertEqual(reactor.currentState.movies.count, 3)
        
        reactor.action.onNext(.didTapSortOrderByLastRegisteredAction)
        
        reactor.state
            .map { $0.movies }
            .subscribe(onNext: {
                XCTAssertEqual($0[0].id, -3)
                XCTAssertEqual($0[1].id, -2)
                XCTAssertEqual($0[2].id, -1)
            })
            .dispose()
        
        reactor.action.onNext(.didTapSortOrderByLastRegisteredAction)
        
        reactor.state
            .map { $0.movies }
            .subscribe(onNext: {
                XCTAssertEqual($0[0].id, -1)
                XCTAssertEqual($0[1].id, -2)
                XCTAssertEqual($0[2].id, -3)
            })
            .dispose()
    }
    
    func test_didTapSortOrderByRateAction() {
        let useCase = StubFavoriteUseCase()
        reactor = FavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.movies.isEmpty, true)
        
        // 기존 Movie 정렬을 위해 미리 Movie 세팅
        reactor.action.onNext(.fetchFavoriteMovies)
        
        XCTAssertEqual(reactor.currentState.movies.count, 3)
        
        reactor.action.onNext(.didTapSortOrderByRateAction)
        
        reactor.state
            .map { $0.movies }
            .subscribe(onNext: {
                print($0)
                XCTAssertEqual($0[0].id, -3)
                XCTAssertEqual($0[1].id, -2)
                XCTAssertEqual($0[2].id, -1)
            })
            .dispose() // 같은 State를 구독하는 곳이 두 곳이므로 평점 높은 순으로 정렬시 구독하는 두 곳중 하나의 테스트는 틀리게되므로 바로 구독을 끊도록 dispose를 사용하였음
        
        reactor.action.onNext(.didTapSortOrderByRateAction)
        
        reactor.state
            .map { $0.movies }
            .subscribe(onNext: {
                XCTAssertEqual($0[0].id, -1)
                XCTAssertEqual($0[1].id, -2)
                XCTAssertEqual($0[2].id, -3)
            })
            .dispose()
    }
    
    func test_isUpdate_true() {
        let useCase = StubFavoriteUseCase()
        reactor = FavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(FavoriteViewReactor.Action.isUpdate(.fetchFavoriteMovies), true)
    }
    
    func test_isUpdate_false() {
        let useCase = StubFavoriteUseCase()
        reactor = FavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(FavoriteViewReactor.Action.isUpdate(.didTapFavoriteButton(.empty)), false)
        XCTAssertEqual(FavoriteViewReactor.Action.isUpdate(.didTapSortOrderByLastRegisteredAction), false)
        XCTAssertEqual(FavoriteViewReactor.Action.isUpdate(.didTapSortOrderByRateAction), false)
    }
}
