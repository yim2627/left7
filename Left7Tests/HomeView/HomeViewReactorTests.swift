//
//  HomeViewReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

import RxSwift

final class HomeViewReactorTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag()
    var reactor: YogiHomeViewReactor!
    
    func test_didTapFavoriteButton() {
        reactor = YogiHomeViewReactor()
        
        reactor.initialState.products = [
            .empty
        ]
        
        reactor.action.onNext(.didTapFavoriteButton(0))
        
        XCTAssertEqual(reactor.currentState.products[0].isFavorite, true)
        
        reactor.action.onNext(.didTapFavoriteButton(0))
        
        XCTAssertEqual(reactor.currentState.products[0].isFavorite, false)
    }
    
    func test_loadNextPage() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        reactor.initialState.page = 1
        
        XCTAssertEqual(reactor.currentState.page, 1)
        
        reactor.action.onNext(.loadNextPage)
        
        reactor.state
            .map { $0.page }
            .subscribe(onNext: {
                XCTAssertEqual($0, 2)
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0.count, 3)
            })
            .disposed(by: disposeBag)
    }
    
    func test_fetchProducts() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        reactor.action.onNext(.fetchProducts)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0.count, 3)
            })
            .disposed(by: disposeBag)
    }
    
    func test_fetchFavoriteProducts() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        reactor.action.onNext(.fetchFavoriteProducts)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0.isEmpty, true) // 새 모델을 내리기위해 비교할 모델이 없으므로 empty
            })
            .disposed(by: disposeBag)
    }
    
    func test_updateFavoriteProducts() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        reactor.action.onNext(.fetchProducts)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0.count, 3)
            })
            .disposed(by: disposeBag)
        
        reactor.action.onNext(.fetchFavoriteProducts)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0[0].isFavorite, true)
                XCTAssertEqual($0[1].isFavorite, true)
                XCTAssertEqual($0[2].isFavorite, false)
            })
            .disposed(by: disposeBag)
    }
    
    func test_isLoadNextPage_true() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        reactor.initialState.isLoadingNextPage = true
        
        XCTAssertEqual(reactor.currentState.isLoadingNextPage, true)
    }
    
    func test_isLoadNextPage_false() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        reactor.initialState.isLoadingNextPage = false
        
        XCTAssertEqual(reactor.currentState.isLoadingNextPage, false)
    }
    
    func test_isUpdate_true() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        XCTAssertEqual(YogiHomeViewReactor.Action.isUpdate(.fetchProducts), true)
    }
    
    func test_isUpdate_false() {
        let usecase = StubHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: usecase)
        
        XCTAssertEqual(YogiHomeViewReactor.Action.isUpdate(.didTapFavoriteButton(0)), false)
    }
}

