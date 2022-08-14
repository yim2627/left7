//
//  HomeUseCaseTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

class HomeUseCaseTests: XCTestCase {
    private var testMovies: [Movie]!
    private var testFavoriteMovies: [Movie]!
    
    private var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        testMovies = [
            Movie(
                id: -1,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -1,
                isFavorite: false
            ),
            Movie(
                id: -2,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -2,
                isFavorite: false
            ),
            Movie(
                id: -3,
                name: "",
                posterPath: "",
                descriptionSubject: "",
                rate: -3,
                isFavorite: false
            )
        ]
        
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
    
    func test_fetchMovies() {
        let networkRepository = MockMovieRepository(data: testMovies)
        let coreDataRepository = MockFavoriteMovieRepository(data: testFavoriteMovies)
        
        let useCase = HomeUseCase(
            movieRepository: networkRepository,
            favoriteMovieRepository: coreDataRepository
        )
        
        let page = 1
        
        useCase.fetchMovies(page: page)
            .subscribe(onNext: { movies in
                XCTAssertEqual(!self.testMovies[0].isFavorite, movies[0].isFavorite)
                XCTAssertEqual(!self.testMovies[2].isFavorite, movies[2].isFavorite)
                networkRepository.verifyFetchMovies(page: page)
            })
            .disposed(by: disposeBag)
    }
    
    func test_fetchFavoriteMovies() {
        let networkRepository = MockMovieRepository(data: testMovies)
        let coreDataRepository = MockFavoriteMovieRepository(data: testFavoriteMovies)
        
        let useCase = HomeUseCase(
            movieRepository: networkRepository,
            favoriteMovieRepository: coreDataRepository
        )
        
        useCase.fetchFavoriteMovies()
            .subscribe(onNext: { favoriteMovies in
                XCTAssertEqual(self.testFavoriteMovies, favoriteMovies)
                coreDataRepository.verifyFetchFavoriteMovie()
            })
            .disposed(by: disposeBag)
    }
    
    func test_updateFavoriteMovie_whenIsFavoriteMovie() {
        let networkRepository = MockMovieRepository(data: testMovies)
        let coreDataRepository = MockFavoriteMovieRepository(data: testFavoriteMovies)
        
        let useCase = HomeUseCase(
            movieRepository: networkRepository,
            favoriteMovieRepository: coreDataRepository
        )
        
        let movie = Movie(
            id: -4,
            name: "",
            posterPath: "",
            descriptionSubject: "",
            rate: -4,
            isFavorite: true
        )
        
        useCase.updateFavoriteMovies(movie)
        coreDataRepository.verifySaveFavoriteMovie(movie: movie)
    }
    
    func test_updateFavoriteMovie_whenIsNotFavoriteMovie() {
        let networkRepository = MockMovieRepository(data: testMovies)
        let coreDataRepository = MockFavoriteMovieRepository(data: testFavoriteMovies)
        
        let useCase = HomeUseCase(
            movieRepository: networkRepository,
            favoriteMovieRepository: coreDataRepository
        )
        
        let movie = Movie(
            id: -4,
            name: "",
            posterPath: "",
            descriptionSubject: "",
            rate: -4,
            isFavorite: false
        )
    
        useCase.updateFavoriteMovies(movie)
        coreDataRepository.verifyDeleteFavoriteMovie(movie: movie)
    }
}



