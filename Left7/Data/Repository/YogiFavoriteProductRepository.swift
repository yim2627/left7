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
        return .empty()
    }
    
    func saveFavoriteProduct(_ product: Product) {
        coreDataManager.save(product)
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        
    }
}
