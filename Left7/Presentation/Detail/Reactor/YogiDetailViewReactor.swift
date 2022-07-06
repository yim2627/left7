//
//  YogiDetailViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift
import RxCocoa

import ReactorKit

final class YogiDetailViewReactor: Reactor {
    private let useCase: YogiDetailUsecaseType
    var initialState: State
    
    init(useCase: YogiDetailUsecaseType = YogiDetailUsecase(), selectedProduct: Product) {
        self.useCase = useCase
        self.initialState = State(product: selectedProduct)
    }
    
    enum Action {
        case didInit
        case didTapFavoriteButton
    }
    
    enum Mutation {
        case setProduct
        case toggleFavoriteState
    }
    
    struct State {
        var product: Product?
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setProduct:
            return state
            
        case .toggleFavoriteState:
            var newState = state
            let updatedProduct = toggleFavoriteState(previousState: state)
            newState.product = updatedProduct
            
            return newState
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didInit:
            return Observable.just(Mutation.setProduct)
            
        case .didTapFavoriteButton:
            return Observable.just(Mutation.toggleFavoriteState)
        }
    }
}

extension YogiDetailViewReactor {
    func toggleFavoriteState(previousState: State) -> Product {
        guard var product = previousState.product else {
            return .empty
        }
        
        product.isFavorite.toggle()
        product.favoriteRegistrationTime = product.isFavorite ? Date() : nil
        
        useCase.updateFavoriteProduct(product)
        
        return product
    }
}
