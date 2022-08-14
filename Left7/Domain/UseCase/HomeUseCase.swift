//
//  HomeUseCase.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift

final class HomeUseCase: HomeUseCaseType {
    //MARK: - Properties

    private let movieRepository: NetworkRepository
    private let favoriteMovieRepository: CoreDataRepository
    
    //MARK: - Init

    init(
        movieRepository: NetworkRepository = MovieRepository(),
        favoriteMovieRepository: CoreDataRepository = FavoriteMovieRepository()
    ) {
        self.movieRepository = movieRepository
        self.favoriteMovieRepository = favoriteMovieRepository
    }
    
    //MARK: - Method

    func fetchMovies(page: Int) -> Observable<[Movie]> {
        return Observable.zip(
            movieRepository.fetchMovies(page: page),
            favoriteMovieRepository.fetchFavoriteMovies()
        )
        .map { movies, favoriteMovies in
            let favoriteMoviesId = favoriteMovies.map { $0.id } // 로컬에 저장된 찜한 Movie의 id값과 서버에서 내려오는 Movie들의 id값이 포함되어있을시 isfavorite true로 변환하여 내려주는 것
            
            return movies.map {
                return Movie(
                    id: $0.id,
                    name: $0.name,
                    posterPath: $0.posterPath,
                    descriptionSubject: $0.descriptionSubject,
                    rate: $0.rate,
                    isFavorite: favoriteMoviesId.contains($0.id),
                    favoriteRegistrationTime: $0.favoriteRegistrationTime
                )
            }
        }
    }
    
    func fetchFavoriteMovies() -> Observable<[Movie]> {
        favoriteMovieRepository.fetchFavoriteMovies()
    }
    
    func updateFavoriteMovies(_ movie: Movie?) {
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
