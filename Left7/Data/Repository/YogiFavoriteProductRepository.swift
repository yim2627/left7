//
//  YogiFavoriteProductRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

import RxSwift
import CoreData

final class YogiFavoriteProductRepository: CoreDataRepository {
    //MARK: - Properties

    private let coreDataManager: CoreDataManager
    
    //MARK: - Init

    init(manager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = manager
    }
    
    //MARK: - Method

    func fetchFavoriteProduct() -> Observable<[Product]> {
        return coreDataManager.fetch(type: ProductDataObject.self) // 저장되어있는 데이터의 타입과 내가 부를 데이터의 타입이 서로 상속관계여도 타입이 완전히 동일하지않으면 뒤진다.
            .map {
                $0.map {
                    $0.toDomain()
                }
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
        productObject.isFavorite = product.isFavorite
        productObject.favoriteRegistrationTime = product.favoriteRegistrationTime
        
        coreDataManager.saveContext()
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        coreDataManager.delete(with: product.id)
    }
}
