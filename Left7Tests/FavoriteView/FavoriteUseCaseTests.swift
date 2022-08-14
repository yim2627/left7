//
//  FavoriteUseCaseTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

class FavoriteUseCaseTests: XCTestCase {
    private var testFavoriteMovies: [Movie]!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        testFavoriteMovies = [
            Movie(
                id: -1,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: true
            ),
            Movie(
                id: -3,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -3,
                isFavorite: true
            )
        ]
        
        disposeBag = DisposeBag()
    }
    
    func test_fetchFavoriteMovies() {
        let coreDataRepository = MockFavoriteMovieRepository(data: testFavoriteMovies)
        
        let useCase = FavoriteUseCase(favoriteMovieRepository: coreDataRepository)
        
        useCase.fetchFavoriteMovies()
            .subscribe(onNext: { favoriteMovies in
                XCTAssertEqual(self.testFavoriteMovies, favoriteMovies)
                coreDataRepository.verifyFetchFavoriteMovie()
            })
            .disposed(by: disposeBag)
    }
    
    func test_deleteFavoriteMovie() {
        let coreDataRepository = MockFavoriteMovieRepository(data: testFavoriteMovies)
        
        let useCase = FavoriteUseCase(favoriteMovieRepository: coreDataRepository)
        
        let movie = Movie(
            id: -4,
            name: "",
            posterPath: "",
            descriptionSubject: "",
            rate: -4,
            isFavorite: false
        )
        
        useCase.deleteFavoriteMovie(movie)
        coreDataRepository.verifyDeleteFavoriteMovie(movie: movie)
    }
}
