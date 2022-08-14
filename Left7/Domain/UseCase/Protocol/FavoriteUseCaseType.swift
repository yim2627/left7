//
//  FavoriteUseCaseType.swift
//  Left7
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation

import RxSwift

protocol FavoriteUseCaseType {
    func fetchFavoriteMovies() -> Observable<[Movie]>
    func deleteFavoriteMovie(_ movie: Movie)
}
