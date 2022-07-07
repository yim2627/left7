//
//  YogiFavoriteUsecaseType.swift
//  Left7
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation

import RxSwift

protocol YogiFavoriteUseCaseType {
    func fetchFavoriteProduct() -> Observable<[Product]>
    func deleteFavoriteProduct(_ product: Product)
}
