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
    var reactor: YogiFavoriteViewReactor!
    
    func test_fetchFavoriteProducts() {
        let useCase = StubFavoriteUseCase()
        reactor = YogiFavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        reactor.action.onNext(.fetchFavoriteProducts)
        
        reactor.state
            .map { $0.products }
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
        reactor = YogiFavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        // 기존 프로젝트 isFavorite toggle 확인을 위해 미리 프로젝트 세팅
        reactor.action.onNext(.fetchFavoriteProducts)
        
        XCTAssertEqual(reactor.currentState.products.count, 3)
        
        let defaultProduct: Product = .empty
        
        reactor.action.onNext(.didTapFavoriteButton(defaultProduct))
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0.map { $0.id }.contains(defaultProduct.id), false)
            })
            .disposed(by: disposeBag)
    }
    
    func test_didTapSortOrderByLastRegisteredAction() {
        let useCase = StubFavoriteUseCase()
        reactor = YogiFavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        // 기존 프로젝트 정렬을 위해 미리 프로젝트 세팅
        reactor.action.onNext(.fetchFavoriteProducts)
        
        XCTAssertEqual(reactor.currentState.products.count, 3)
        
        reactor.action.onNext(.didTapSortOrderByLastRegisteredAction)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0[0].id, -3)
                XCTAssertEqual($0[1].id, -2)
                XCTAssertEqual($0[2].id, -1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_didTapSortOrderByRateAction() {
        let useCase = StubFavoriteUseCase()
        reactor = YogiFavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(reactor.currentState.products.isEmpty, true)
        
        // 기존 프로젝트 정렬을 위해 미리 프로젝트 세팅
        reactor.action.onNext(.fetchFavoriteProducts)
        
        XCTAssertEqual(reactor.currentState.products.count, 3)
        
        reactor.action.onNext(.didTapSortOrderByRateAction)
        
        reactor.state
            .map { $0.products }
            .subscribe(onNext: {
                XCTAssertEqual($0[0].id, -3)
                XCTAssertEqual($0[1].id, -2)
                XCTAssertEqual($0[2].id, -1)
            })
            .disposed(by: disposeBag)
    }
    
    func test_isUpdate_true() {
        let useCase = StubFavoriteUseCase()
        reactor = YogiFavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(YogiFavoriteViewReactor.Action.isUpdate(.fetchFavoriteProducts), true)
    }
    
    func test_isUpdate_false() {
        let useCase = StubFavoriteUseCase()
        reactor = YogiFavoriteViewReactor(useCase: useCase)
        
        XCTAssertEqual(YogiFavoriteViewReactor.Action.isUpdate(.didTapFavoriteButton(.empty)), false)
        XCTAssertEqual(YogiFavoriteViewReactor.Action.isUpdate(.didTapSortOrderByLastRegisteredAction), false)
        XCTAssertEqual(YogiFavoriteViewReactor.Action.isUpdate(.didTapSortOrderByRateAction), false)
    }
}
