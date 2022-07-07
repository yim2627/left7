//
//  YogiHomeUsecaseType.swift
//  Left7
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation

import RxSwift

protocol YogiHomeUseCaseType {
    func fetchProducts(page: Int) -> Observable<[Product]>
    func fetchFavoriteProduct() -> Observable<[Product]>
    func updateFavoriteProduct(_ product: Product?)
}
