//
//  StubHomeUsecase.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

import RxSwift

final class StubHomeUsecase: YogiHomeUsecaseType {
    func fetchProducts(page: Int) -> Observable<[Product]> {
        return Observable.just([
            Product(
                id: -1,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: false),
            Product(
                id: -2,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: false),
            Product(
                id: -3,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: false)
        ])
    }
    
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
                isFavorite: true),
            Product(
                id: -2,
                name: "",
                thumbnailPath: "",
                descriptionImagePath: "",
                descriptionSubject: "",
                price: -1,
                rate: -1,
                isFavorite: true)
        ])
    }
    
    func updateFavoriteProduct(_ product: Product?) {
        return
    }
}
