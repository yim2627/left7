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
}
