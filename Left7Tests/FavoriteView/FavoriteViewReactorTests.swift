//
//  FavoriteViewReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

import RxSwift

class FavoriteViewReactorTests: XCTestCase {
    var disposeBag: DisposeBag = DisposeBag()
    var reactor: YogiFavoriteViewReactor!
    
    func test_fetchFavoriteProducts() {
        let usecase = StubFavoriteUsecase()
        reactor = YogiFavoriteViewReactor(useCase: usecase)
        
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
        let usecase = StubFavoriteUsecase()
        reactor = YogiFavoriteViewReactor(useCase: usecase)
        
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
}
