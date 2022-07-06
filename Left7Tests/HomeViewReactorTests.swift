//
//  HomeViewReactorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

import RxSwift

class HomeViewReactorTests: XCTestCase {
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
        let useCase = MockHomeUsecase()
        reactor = YogiHomeViewReactor(useCase: useCase)
        reactor.initialState.page = 1
        
        XCTAssertEqual(reactor.currentState.page, 1)
        
        reactor.action.onNext(.loadNextPage)
        
        reactor.state
            .map { $0.page }
            .subscribe(onNext: {
                XCTAssertEqual($0, 2)
            })
            .disposed(by: disposeBag)
    }
}

final class MockHomeUsecase: YogiHomeUsecaseType {
    func fetchProducts(page: Int) -> Observable<[Product]> {
        return Observable.just([
            .empty,
            .empty,
            .empty
        ])
    }
    
    func fetchFavoriteProduct() -> Observable<[Product]> {
        return .empty()
    }
    
    func updateFavoriteProduct(_ product: Product?) {
//        <#code#>
    }
}
