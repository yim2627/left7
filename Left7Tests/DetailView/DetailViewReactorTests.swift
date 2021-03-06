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
    var reactor: YogiDetailViewReactor!
    
    func test_didTapFavoriteButton() {
        let useCase = StubDetailUseCase()
        reactor = YogiDetailViewReactor(useCase: useCase, selectedProduct: .empty) // isFavorite: False
        
        reactor.action.onNext(.didTapFavoriteButton)
        
        XCTAssertEqual(reactor.currentState.product?.isFavorite, true)
        
        reactor.action.onNext(.didTapFavoriteButton)
        
        XCTAssertEqual(reactor.currentState.product?.isFavorite, false)
    }
    
    func test_didTapFavoriteButton_with_abnormal_product() {
        let useCase = StubDetailUseCase()
        reactor = YogiDetailViewReactor(useCase: useCase, selectedProduct: nil)
        
        reactor.action.onNext(.didTapFavoriteButton)
        
        XCTAssertEqual(reactor.currentState.product, .empty)
    }
}
