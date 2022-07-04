//
//  YogiFavoriteProductRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

import RxSwift

final class YogiFavoriteProductRepository: CoreDataRepository {
    let coreDataManager: CoreDataManager
    
    init(manager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = manager
    }
    
    func fetchFavoriteProduct() -> Observable<[Product]> {
        return coreDataManager.fetch()
            .map { productObject in
                productObject.map { $0.toDomain() }
            }
    }
    
    func saveFavoriteProduct(_ product: Product) {
        let productObject = ProductDataObject(context: coreDataManager.context)
        productObject.id = product.id
        productObject.name = product.name
        productObject.thumbnailPath = product.thumbnailPath
        productObject.descriptionImagePath = product.descriptionImagePath
        productObject.descriptionSubject = product.descriptionSubject
        productObject.price = product.price
        productObject.rate = product.rate
        productObject.isFavorite = true
        productObject.favoriteRegistrationTime = Date()
        
        coreDataManager.saveContext()
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        
    }
}