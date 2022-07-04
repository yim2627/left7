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
        case fetchFavoriteProducts
        case loadNextPage
        case didTapFavoriteButton(Int)
    }
    
    enum Mutation {
        case setProducts([Product])
        case setFavoriteProducts([Product])
        case appendProducts([Product], page: Int)
        case setLoadingNextPage(Bool)
        case toggleFavoriteState(index: Int)
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
        case let .setFavoriteProducts(products):
            var newState = state
            let updatedProduct = updateProducts(previousState: state, favoriteProjects: products)
            newState.products = updatedProduct
            return newState
        case let .appendProducts(products, page: page):
            var newState = state
            newState.products.append(contentsOf: products)	
            newState.page = page
            return newState
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
        case let .toggleFavoriteState(index: index):
            var newState = state
            let updatedProduct = toggleFavoriteState(previousState: newState, index: index)
            newState.products[index] = updatedProduct
            return newState
        }
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchProducts:
            return useCase.fetchProducts(page: self.currentState.page)
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setProducts($0) }
            
        case .fetchFavoriteProducts:
            return useCase.fetchFavoriteProduct()
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setFavoriteProducts($0) }
            
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return .empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                useCase.fetchProducts(page: self.currentState.page + 1)
                    .take(until: self.action.filter(Action.isUpdate))
                    .filter { $0.isEmpty == false }
                    .map { Mutation.appendProducts($0, page: self.currentState.page + 1) },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
            
        case let .didTapFavoriteButton(index):
            return Observable.just(Mutation.toggleFavoriteState(index: index))
        }
    }
}

private extension YogiHomeViewReactor {
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
    
    func updateProducts(previousState: State, favoriteProjects: [Product]) -> [Product] {
        let favoriteProjectId = favoriteProjects.map { $0.id }
        
        return previousState.products.map {
            return Product(
                id: $0.id,
                name: $0.name,
                thumbnailPath: $0.thumbnailPath,
                descriptionImagePath: $0.descriptionImagePath,
                descriptionSubject: $0.descriptionSubject,
                price: $0.price,
                rate: $0.rate,
                isFavorite: favoriteProjectId.contains($0.id),
                favoriteRegistrationTime: $0.favoriteRegistrationTime
            )
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
