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
    //MARK: - Properties

    private let useCase: YogiHomeUsecaseType
    var initialState: State = State()
    
    //MARK: - Init

    init(useCase: YogiHomeUsecaseType = YogiHomeUsecase()) {
        self.useCase = useCase
    }
    
    //MARK: - Model

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
    
    //MARK: - Reduce

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
    
    //MARK: - Mutate

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
                    .map { [unowned self] in
                        Mutation.appendProducts($0, page: self.currentState.page + 1)
                    },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
            
        case let .didTapFavoriteButton(index):
            return Observable.just(Mutation.toggleFavoriteState(index: index))
        }
    }
}

private extension YogiHomeViewReactor {
    func toggleFavoriteState(previousState: State, index: Int) -> Product {
        var product = previousState.products[index]
        
        product.isFavorite.toggle()
        product.favoriteRegistrationTime = product.isFavorite ? Date() : nil
        
        useCase.updateFavoriteProduct(product)
        
        return product
    }
    
    // 서버에서 가져오는 행위를 한번만 하기위해(비용 감소) 기존 State와 비교하여 데이터를 내려줌 -> 즐겨찾기의 상태는 어느 뷰에서든 가능하기 때문에 항시 찜목록은 가져와야함
    func updateProducts(previousState: State, favoriteProjects: [Product]) -> [Product] {
        let favoriteProjectId = favoriteProjects.map { $0.id }
        
        return previousState.products.map {
            var product = $0
            product.isFavorite = favoriteProjectId.contains(product.id)
            
            return product
        }
    }
}

private extension YogiHomeViewReactor.Action {
    static func isUpdate(_ action: YogiHomeViewReactor.Action) -> Bool {
        if case .fetchProducts = action {
            return true
        } else {
            return false
        }
    }
}
