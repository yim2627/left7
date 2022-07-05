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
            let updatedProduct = toggleFavoriteState(previousState: state, index: index)
            newState.products[index] = updatedProduct
            return newState
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchFavoriteProducts:
            return useCase.fetchFavoriteProduct()
                .map { Mutation.setFavoriteProducts($0) }
            
        case let .didTapFavoriteButton(index):
            return Observable.just(Mutation.toggleFavoriteState(index: index))
        }
    }
}

extension YogiFavoriteViewReactor {
    func toggleFavoriteState(previousState: State, index: Int) -> Product {
        let product = Product(
            id: previousState.products[index].id,
            name: previousState.products[index].name,
            thumbnailPath: previousState.products[index].thumbnailPath,
            descriptionImagePath: previousState.products[index].descriptionImagePath,
            descriptionSubject: previousState.products[index].descriptionSubject,
            price: previousState.products[index].price,
            rate: previousState.products[index].rate,
            isFavorite: !previousState.products[index].isFavorite,
            favoriteRegistrationTime: !previousState.products[index].isFavorite ? Date() : nil
        )
        
        useCase.updateFavoriteProduct(product)
        
        return product
    }
}
