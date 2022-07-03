//
//  YogiHomeViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift
import RxCocoa

import ReactorKit

final class YogiHomeViewReactor: Reactor {
    private let useCase = YogiHomeUsecase()
    var initialState: State = State()
    
    enum Action {
        case fetchProducts
        case loadNextPage
    }
    
    enum Mutation {
        case setProducts([Product])
        case appendProducts([Product], page: Int)
        case setLoadingNextPage(Bool)
    }
    
    struct State {
        var products: [Product] = []
        var page: Int = 1
        var isLoadingNextPage: Bool = false
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setProducts(products):
            var newState = state
            newState.products = products
            return newState
        case let .appendProducts(products, page: page):
            var newState = state
            newState.products = products
            newState.page = page
            return newState
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProducts:
            return useCase.fetchProducts(page: self.currentState.page)
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setProducts($0) }
            
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return .empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                useCase.fetchProducts(page: self.currentState.page)
                    .take(until: self.action.filter(Action.isUpdate))
                    .map { Mutation.appendProducts($0, page: self.currentState.page + 1) },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
        }
    }
}

extension YogiHomeViewReactor.Action {
    static func isUpdate(_ action: YogiHomeViewReactor.Action) -> Bool {
        if case .fetchProducts = action {
            return true
        } else {
            return false
        }
    }
}
