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
    var initialState: State = State()
    
    enum Action {
        case fetchFavoriteProducts
        case didTapFavoriteButton(Int)
    }
    
    enum Mutation {
        case setFavoriteProducts([Product])
        case toggleFavoriteState(index: Int)
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
        case let .toggleFavoriteState(index: index):
            var newState = state
            return newState
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchFavoriteProducts:
            return .empty()
        case let .didTapFavoriteButton(index):
            return Observable.just(Mutation.toggleFavoriteState(index: index))
        }
    }
}
