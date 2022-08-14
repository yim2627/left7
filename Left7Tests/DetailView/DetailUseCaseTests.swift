//
//  DetailUseCaseTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class DetailUseCaseTests: XCTestCase {
    func test_updateFavoriteMovie_whenIsFavoriteMovie() {
        let coreDataRepository = MockFavoriteMovieRepository()
        
        let useCase = DetailUseCase(favoriteMovieRepository: coreDataRepository)
        
        let movie = Movie(
            id: -4,
            name: "",
            posterPath: "",
            descriptionSubject: "",
            rate: -4,
            isFavorite: true
        )
        
        useCase.updateFavoriteMovie(movie)
        coreDataRepository.verifySaveFavoriteMovie(movie: movie)
    }
    
    func test_updateFavoriteMovie_whenIsNotFavoriteMovie() {
        let coreDataRepository = MockFavoriteMovieRepository()
        
        let useCase = DetailUseCase(favoriteMovieRepository: coreDataRepository)
        
        let movie = Movie(
            id: -4,
            name: "",
            posterPath: "",
            descriptionSubject: "",
            rate: -4,
            isFavorite: false
        )
    
        useCase.updateFavoriteMovie(movie)
        coreDataRepository.verifyDeleteFavoriteMovie(movie: movie)
    }
}
