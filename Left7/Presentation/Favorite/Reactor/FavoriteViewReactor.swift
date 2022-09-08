//
//  FavoriteViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

import RxSwift

import ReactorKit

protocol FavoriteViewReactorDependencyType: AnyObject {
	var useCase: FavoriteUseCaseType { get }
}

final class FavoriteViewReactorDependency: FavoriteViewReactorDependencyType {
	let useCase: FavoriteUseCaseType
	
	init(useCase: FavoriteUseCaseType) {
		self.useCase = useCase
	}
}

final class FavoriteViewReactor: Reactor {
    //MARK: - Properties

    private let dependency: FavoriteViewReactorDependencyType
    var initialState: State = State()
    
    //MARK: - Init

    init(dependency: FavoriteViewReactorDependencyType) {
        self.dependency = dependency
    }
    
    //MARK: - Model

    enum Action {
        case fetchFavoriteMovies
        case didTapFavoriteButton(Movie)
        case didTapSortOrderByLastRegisteredAction
        case didTapSortOrderByRateAction
    }
    
    enum Mutation {
        case setFavoriteMovies([Movie])
        case removeFavoriteMovie(Movie)
        case sortOrderByLateRegistered
        case sortOrderByRate
    }
    
    struct State {
        var movies: [Movie] = []
        var isSortOrderByLateRegistered: Bool = false
        var isSortOrderByRate: Bool = false
    }
    
    //MARK: - Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setFavoriteMovies(movies):
            var newState = state
            newState.movies = movies
            newState.movies.sort {
                $0.favoriteRegistrationTime ?? Date() > $1.favoriteRegistrationTime ?? Date() // 초기 정렬
            }
            
            return newState
    
        case let .removeFavoriteMovie(movie):
            var newState = state
            removeFavoriteMovie(previousState: state, movie: movie)
            newState.movies.removeAll {
                $0.id == movie.id
            }
            
            return newState
            
        case .sortOrderByLateRegistered:
            var newState = state
            if state.isSortOrderByLateRegistered { // 오래된순
                newState.movies
                    .sort {
                        $0.favoriteRegistrationTime ?? Date() < $1.favoriteRegistrationTime ?? Date() // 오름차순
                    }
            } else {
                newState.movies // 최신순
                    .sort {
                        $0.favoriteRegistrationTime ?? Date() > $1.favoriteRegistrationTime ?? Date() // 내림차순
                    }
            }
            
            newState.isSortOrderByLateRegistered = !state.isSortOrderByLateRegistered
            
            return newState
            
        case .sortOrderByRate:
            var newState = state
            
            if state.isSortOrderByRate { // 낮은순
                newState.movies.sort { $0.rate < $1.rate } // 오름차순
            } else { // 높은순
                newState.movies.sort { $0.rate > $1.rate } // 내림차순
            }
            
            newState.isSortOrderByRate = !state.isSortOrderByRate
            
            return newState
        }
    }
    
    //MARK: - Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchFavoriteMovies:
						return dependency.useCase.fetchFavoriteMovies()
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setFavoriteMovies($0) }
            
        case let .didTapFavoriteButton(movie):
            return Observable.just(Mutation.removeFavoriteMovie(movie))
            
        case .didTapSortOrderByLastRegisteredAction:
            return Observable.just(Mutation.sortOrderByLateRegistered)
            
        case .didTapSortOrderByRateAction:
            return Observable.just(Mutation.sortOrderByRate)
        }
    }
}

private extension FavoriteViewReactor {
    func removeFavoriteMovie(previousState: State, movie: Movie) {
			dependency.useCase.deleteFavoriteMovie(movie)
    }
}

extension FavoriteViewReactor.Action {
    static func isUpdate(_ action: FavoriteViewReactor.Action) -> Bool {
        if case .fetchFavoriteMovies = action {
            return true
        } else {
            return false
        }
    }
}
