//
//  CoreDataRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

import RxSwift

protocol CoreDataRepository {
    func fetchFavoriteProduct() -> Observable<[Product]>
    func saveFavoriteProduct(_ product: Product)
    func deleteFavoriteProduct(_ product: Product)
}
