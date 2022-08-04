//
//  YogiFavoriteViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

import RxSwift

import ReactorKit

final class YogiFavoriteViewReactor: Reactor {
    //MARK: - Properties

    private let useCase: YogiFavoriteUseCaseType
    var initialState: State = State()
    
    //MARK: - Init

    init(useCase: YogiFavoriteUseCaseType = YogiFavoriteUseCase()) {
        self.useCase = useCase
    }
    
    //MARK: - Model

    enum Action {
        case fetchFavoriteProducts
        case didTapFavoriteButton(Product)
        case didTapSortOrderByLastRegisteredAction
        case didTapSortOrderByRateAction
    }
    
    enum Mutation {
        case setFavoriteProducts([Product])
        case removeFavoriteProduct(Product)
        case sortOrderByLateRegistered
        case sortOrderByRate
    }
    
    struct State {
        var products: [Product] = []
        var isSortOrderByLateRegistered: Bool = false
        var isSortOrderByRate: Bool = false
    }
    
    //MARK: - Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setFavoriteProducts(products):
            var newState = state
            newState.products = products
            newState.products.sort {
                $0.favoriteRegistrationTime ?? Date() > $1.favoriteRegistrationTime ?? Date() // 초기 정렬
            }
            
            return newState
    
        case let .removeFavoriteProduct(product):
            var newState = state
            removeFavoriteProduct(previousState: state, product: product)
            newState.products.removeAll {
                $0.id == product.id
            }
            
            return newState
            
        case .sortOrderByLateRegistered:
            var newState = state
            if state.isSortOrderByLateRegistered { // 오래된순
                newState.products
                    .sort {
                        $0.favoriteRegistrationTime ?? Date() < $1.favoriteRegistrationTime ?? Date() // 오름차순
                    }
            } else {
                newState.products // 최신순
                    .sort {
                        $0.favoriteRegistrationTime ?? Date() > $1.favoriteRegistrationTime ?? Date() // 내림차순
                    }
            }
            
            newState.isSortOrderByLateRegistered = !state.isSortOrderByLateRegistered
            
            return newState
            
        case .sortOrderByRate:
            var newState = state
            
            if state.isSortOrderByRate { // 낮은순
                newState.products.sort { $0.rate < $1.rate } // 오름차순
            } else { // 높은순
                newState.products.sort { $0.rate > $1.rate } // 내림차순
            }
            
            newState.isSortOrderByRate = !state.isSortOrderByRate
            
            return newState
        }
    }
    
    //MARK: - Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchFavoriteProducts:
            return useCase.fetchFavoriteProduct()
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setFavoriteProducts($0) }
            
        case let .didTapFavoriteButton(product):
            return Observable.just(Mutation.removeFavoriteProduct(product))
            
        case .didTapSortOrderByLastRegisteredAction:
            return Observable.just(Mutation.sortOrderByLateRegistered)
            
        case .didTapSortOrderByRateAction:
            return Observable.just(Mutation.sortOrderByRate)
        }
    }
}

private extension YogiFavoriteViewReactor {
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
