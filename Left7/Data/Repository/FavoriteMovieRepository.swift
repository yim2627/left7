//
//  FavoriteMovieRepository.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

import RxSwift
import CoreData

final class FavoriteMovieRepository: CoreDataRepository {
    //MARK: - Properties

    private let coreDataManager: CoreDataManager
    
    //MARK: - Init

    init(manager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = manager
    }
    
    //MARK: - Method

    func fetchFavoriteMovies() -> Observable<[Movie]> {
        return coreDataManager.fetch(type: MovieDataObject.self) // 저장되어있는 데이터의 타입과 내가 부를 데이터의 타입이 서로 상속관계여도 타입이 완전히 동일하지않으면 뒤진다.
            .map {
                $0.map {
                    $0.toDomain()
                }
            }
    }
    
    func saveFavoriteMovie(_ movie: Movie) {
        let movieObject = MovieDataObject(context: coreDataManager.context)
        movieObject.id = movie.id
        movieObject.name = movie.name
        movieObject.posterPath = movie.posterPath
        movieObject.descriptionSubject = movie.descriptionSubject
        movieObject.rate = movie.rate
        movieObject.isFavorite = movie.isFavorite
        movieObject.favoriteRegistrationTime = movie.favoriteRegistrationTime
        
        coreDataManager.saveContext()
    }
    
    func deleteFavoriteMovie(_ movie: Movie) {
        coreDataManager.delete(with: movie.id)
    }
}
