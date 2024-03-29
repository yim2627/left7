//
//  CoreDataRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

import RxSwift

protocol CoreDataRepository {
    func fetchFavoriteMovies() -> Observable<[Movie]>
    func saveFavoriteMovie(_ movie: Movie)
    func deleteFavoriteMovie(_ movie: Movie)
}
