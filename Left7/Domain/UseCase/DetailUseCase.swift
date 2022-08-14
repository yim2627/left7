//
//  DetailUseCase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

final class DetailUseCase: DetailUseCaseType {
    //MARK: - Properties

    private let favoriteMovieRepository: CoreDataRepository
    
    //MARK: - Init

    init(favoriteMovieRepository: CoreDataRepository = FavoriteMovieRepository()) {
        self.favoriteMovieRepository = favoriteMovieRepository
    }
    
    //MARK: - Method

    func updateFavoriteMovie(_ movie: Movie?) {
        guard let movie = movie else {
            return
        }
        
        if movie.isFavorite {
            favoriteMovieRepository.saveFavoriteMovie(movie)
        } else {
            favoriteMovieRepository.deleteFavoriteMovie(movie)
        }
    }
}
