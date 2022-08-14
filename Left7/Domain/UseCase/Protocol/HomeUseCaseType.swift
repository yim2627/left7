//
//  HomeUseCaseType.swift
//  Left7
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation

import RxSwift

protocol HomeUseCaseType {
    func fetchMovies(page: Int) -> Observable<[Movie]>
    func fetchFavoriteMovies() -> Observable<[Movie]>
    func updateFavoriteMovies(_ movies: Movie?)
}

