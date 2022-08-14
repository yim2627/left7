//
//  StubFavoriteUsecase.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

import RxSwift

final class StubFavoriteUseCase: FavoriteUseCaseType {
    func fetchFavoriteMovies() -> Observable<[Movie]> {
        return Observable.just([
            Movie(
                id: -1,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: true,
                favoriteRegistrationTime: Date(timeIntervalSince1970: 10000)
            ),
            Movie(
                id: -2,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: 0,
                isFavorite: true,
                favoriteRegistrationTime: Date(timeIntervalSince1970: 20000)
            ),
            Movie(
                id: -3,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: 1,
                isFavorite: true,
                favoriteRegistrationTime: Date(timeIntervalSince1970: 30000)
            )
        ])
    }
    
    func deleteFavoriteMovie(_ movie: Movie) {
        return 
    }
}
