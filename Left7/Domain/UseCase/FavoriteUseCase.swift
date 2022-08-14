//
//  FavoriteUseCase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

import RxSwift

final class FavoriteUseCase: FavoriteUseCaseType {
    //MARK: - Properties

    private let favoriteMovieRepository: CoreDataRepository
    
    //MARK: - Init

    init(favoriteMovieRepository: CoreDataRepository = FavoriteMovieRepository()) {
        self.favoriteMovieRepository = favoriteMovieRepository
    }
    
    //MARK: - Method

    func fetchFavoriteMovies() -> Observable<[Movie]> {
        favoriteMovieRepository.fetchFavoriteMovies()
    }
    
    func deleteFavoriteMovie(_ movie: Movie) {
        favoriteMovieRepository.deleteFavoriteMovie(movie)
    }
}
