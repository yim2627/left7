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
    var initialState: State
    
    init(selectedProduct: Product) {
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
            // CoreData 저장
        }
    }
}

extension YogiDetailViewReactor {
    func toggleFavoriteState(previousState: State) -> Product {
        return Product(
            id: previousState.product?.id ?? 0,
            name: previousState.product?.name ?? "",
            thumbnailPath: previousState.product?.thumbnailPath ?? "",
            descriptionImagePath: previousState.product?.descriptionImagePath ?? "",
            descriptionSubject: previousState.product?.descriptionSubject ?? "",
            price: previousState.product?.price ?? 0,
            rate: previousState.product?.rate ?? 0,
            isFavorite: !(previousState.product?.isFavorite ?? false),
            favoriteRegistrationTime: nil
        )
    }
}
