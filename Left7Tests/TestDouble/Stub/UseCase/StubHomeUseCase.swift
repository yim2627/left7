//
//  StubHomeUsecase.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

import RxSwift

final class StubHomeUseCase: HomeUseCaseType {
    func fetchMovies(page: Int) -> Observable<[Movie]> {
        return Observable.just([
            Movie(
                id: -1,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: false),
            Movie(
                id: -2,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: false),
            Movie(
                id: -3,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: false)
        ])
    }
    
    func fetchFavoriteMovies() -> Observable<[Movie]> {
        return Observable.just([
            Movie(
                id: -1,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: true),
            Movie(
                id: -2,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: true)
        ])
    }
    
    func updateFavoriteMovies(_ movie: Movie?) {
        return
    }
}
