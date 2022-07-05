//
//  YogiFavoriteUsecase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

import RxSwift

final class YogiFavoriteUsecase {
    private let favoriteProductRepository: CoreDataRepository
    
    init(favoriteProductRepository: CoreDataRepository = YogiFavoriteProductRepository()) {
        self.favoriteProductRepository = favoriteProductRepository
    }
    
    func fetchFavoriteProduct() -> Observable<[Product]> {
        favoriteProductRepository.fetchFavoriteProduct()
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        favoriteProductRepository.deleteFavoriteProduct(product)
    }
}
