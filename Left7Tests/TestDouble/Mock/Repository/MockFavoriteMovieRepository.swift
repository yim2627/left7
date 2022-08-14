//
//  MockFavoriteMovieRepository.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class MockFavoriteMovieRepository: CoreDataRepository {
    private var data: [Movie]
    
    private var saveFavoriteMovie: Movie?
    private var deleteFavoriteMovie: Movie?
    private var fetchFavoriteMoviesCallCount: Int = 0
    private var saveFavoriteMovieCallCount: Int = 0
    private var deleteFavoriteMovieCallCount: Int = 0
    
    init(data: [Movie] = []) {
        self.data = data
    }
    
    func fetchFavoriteMovies() -> Observable<[Movie]> {
        self.fetchFavoriteMoviesCallCount += 1
        
        return Observable.just(data)
    }
    
    func saveFavoriteMovie(_ movie: Movie) {
        self.saveFavoriteMovie = movie
        self.saveFavoriteMovieCallCount += 1
    }
    
    func deleteFavoriteMovie(_ movie: Movie) {
        self.deleteFavoriteMovie = movie
        self.deleteFavoriteMovieCallCount += 1
    }
    
    func verifyFetchFavoriteMovie(callCount: Int = 1) {
        XCTAssertEqual(self.fetchFavoriteMoviesCallCount, callCount)
    }
    
    func verifySaveFavoriteMovie(movie: Movie, callCount: Int = 1) {
        XCTAssertEqual(self.saveFavoriteMovie, movie)
        XCTAssertEqual(self.saveFavoriteMovieCallCount, callCount)
    }
    
    func verifyDeleteFavoriteMovie(movie: Movie, callCount: Int = 1) {
        XCTAssertEqual(self.deleteFavoriteMovie, movie)
        XCTAssertEqual(self.deleteFavoriteMovieCallCount, callCount)
    }
}

