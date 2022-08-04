//
//  YogiHomeUsecase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift

final class YogiHomeUseCase: YogiHomeUseCaseType {
    //MARK: - Properties

    private let productRepository: NetworkRepository
    private let favoriteProductRepository: CoreDataRepository
    
    //MARK: - Init

    init(
        productRepository: NetworkRepository = YogiProductRepository(),
        favoriteProductRepository: CoreDataRepository = YogiFavoriteProductRepository()
    ) {
        self.productRepository = productRepository
        self.favoriteProductRepository = favoriteProductRepository
    }
    
    //MARK: - Method

    func fetchProducts(page: Int) -> Observable<[Product]> {
        return Observable.zip(
            productRepository.fetchYogiProducts(page: page),
            favoriteProductRepository.fetchFavoriteProduct()
        )
        .map { products, favoriteProducts in
            let favoriteProductsId = favoriteProducts.map { $0.id } // 로컬에 저장된 찜한 프로덕트의 id값과 서버에서 내려오는 프로덕트들의 id값이 포함되어있을시 isfavorite true로 변환하여 내려주는 것
            
            return products.map {
                return Product(
                    id: $0.id,
                    name: $0.name,
                    thumbnailPath: $0.thumbnailPath,
                    descriptionImagePath: $0.descriptionImagePath,
                    descriptionSubject: $0.descriptionSubject,
                    price: $0.price,
                    rate: $0.rate,
                    isFavorite: favoriteProductsId.contains($0.id),
                    favoriteRegistrationTime: $0.favoriteRegistrationTime
                )
            }
        }
    }
    
    func fetchFavoriteProduct() -> Observable<[Product]> {
        favoriteProductRepository.fetchFavoriteProduct()
    }
    
    func updateFavoriteProduct(_ product: Product?) {
        guard let product = product else {
            return
        }
        
        if product.isFavorite {
            favoriteProductRepository.saveFavoriteProduct(product)
        } else {
            favoriteProductRepository.deleteFavoriteProduct(product)
        }
    }
}
