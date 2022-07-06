//
//  StubFavoriteUsecase.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

import RxSwift

final class StubFavoriteUsecase: YogiFavoriteUsecaseType {
    func fetchFavoriteProduct() -> Observable<[Product]> {
        return Observable.just([
            Product(
                id: -1,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: true,
                favoriteRegistrationTime: Date(timeIntervalSince1970: 10000)
            ),
            Product(
                id: -2,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: true,
                favoriteRegistrationTime: Date(timeIntervalSince1970: 20000)
            ),
            Product(
                id: -3,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: true,
                favoriteRegistrationTime: Date(timeIntervalSince1970: 30000)
            )
        ])
    }
    
    func deleteFavoriteProduct(_ product: Product) {
        return 
    }
}
