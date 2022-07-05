//
//  YogiFavoriteViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

import RxSwift
import RxCocoa

import ReactorKit

final class YogiFavoriteViewReactor: Reactor {
    private let useCase = YogiFavoriteUsecase()
    var initialState: State = State()
    
    enum Action {
        case fetchFavoriteProducts
        case didTapFavoriteButton(Product)
    }
    
    enum Mutation {
        case setFavoriteProducts([Product])
        case removeFavoriteProduct(Product)
    }
    
    struct State {
        var products: [Product] = []
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setFavoriteProducts(products):
            var newState = state
            newState.products = products
            return newState
        case let .removeFavoriteProduct(product):
            var newState = state
            removeFavoriteProduct(previousState: state, product: product)
            newState.products.removeAll {
                $0.id == product.id
            }
            return newState
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchFavoriteProducts:
            return useCase.fetchFavoriteProduct()
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setFavoriteProducts($0) }
            
        case let .didTapFavoriteButton(product):
            return Observable.just(Mutation.removeFavoriteProduct(product))
        }
    }
}

extension YogiFavoriteViewReactor {
    func removeFavoriteProduct(previousState: State, product: Product) {
        useCase.deleteFavoriteProduct(product)
    }
}

extension YogiFavoriteViewReactor.Action {
    static func isUpdate(_ action: YogiFavoriteViewReactor.Action) -> Bool {
        if case .fetchFavoriteProducts = action {
            return true
        } else {
            return false
        }
    }
}
