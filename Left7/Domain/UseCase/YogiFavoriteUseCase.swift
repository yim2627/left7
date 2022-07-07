//
//  YogiFavoriteUsecase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

import RxSwift

final class YogiFavoriteUseCase: YogiFavoriteUsecaseType {
    //MARK: - Properties

    private let favoriteProductRepository: CoreDataRepository
    
    //MARK: - Init

    init(favoriteProductRepository: CoreDataRepository = YogiFavoriteProductRepository()) {
        self.favoriteProductRepository = favoriteProductRepository
    }
    
    //MARK: - Method

    func fetchFavoriteProduct() -> Observable<[Product]> {
        favoriteProductRepository.fetchFavoriteProduct()
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        favoriteProductRepository.deleteFavoriteProduct(product)
    }
}
