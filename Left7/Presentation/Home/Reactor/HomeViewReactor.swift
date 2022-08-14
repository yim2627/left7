//
//  HomeViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift

import ReactorKit

final class HomeViewReactor: Reactor {
    //MARK: - Properties

    private let useCase: HomeUseCaseType
    var initialState: State = State()
    
    //MARK: - Init

    init(useCase: HomeUseCaseType = HomeUseCase()) {
        self.useCase = useCase
    }
    
    //MARK: - Model

    enum Action {
        case fetchMovies
        case fetchFavoriteMovies
        case loadNextPage
        case didTapFavoriteButton(Int)
    }
    
    enum Mutation {
        case setMovies([Movie])
        case setFavoriteMovies([Movie])
        case appendMovies([Movie], page: Int)
        case setLoadingNextPage(Bool)
        case toggleFavoriteState(index: Int)
    }
    
    struct State {
        var movies: [Movie] = []
        var page: Int = 1
        var isLoadingNextPage: Bool = false
    }
    
    //MARK: - Reduce

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .setMovies(movies):
            var newState = state
            newState.movies = movies
            
            return newState
            
        case let .setFavoriteMovies(movies):
            var newState = state
            let updatedMovie = updateMovies(previousState: state, favoriteMovies: movies)
            newState.movies = updatedMovie
            
            return newState
            
        case let .appendMovies(movies, page: page):
            var newState = state
            newState.movies.append(contentsOf: movies)
            newState.page = page
            
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            
            return newState
            
        case let .toggleFavoriteState(index: index):
            var newState = state
            let updatedMovie = toggleFavoriteState(previousState: newState, index: index)
            newState.movies[index] = updatedMovie
            
            return newState
        }
    }
    
    //MARK: - Mutate

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchMovies:
            return useCase.fetchMovies(page: self.currentState.page)
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setMovies($0) }
            
        case .fetchFavoriteMovies:
            return useCase.fetchFavoriteMovies()
                .take(until: self.action.filter(Action.isUpdate))
                .map { Mutation.setFavoriteMovies($0) }
            
        case .loadNextPage:
            guard !self.currentState.isLoadingNextPage else { return .empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                useCase.fetchMovies(page: self.currentState.page + 1)
                    .take(until: self.action.filter(Action.isUpdate)) // take는 Trigger 시퀀스의 방출이 시작되기 전까지의 요소들만 방출
                    .filter { $0.isEmpty == false }
                    .map { [unowned self] in
                        Mutation.appendMovies($0, page: self.currentState.page + 1)
                    },
                
                Observable.just(Mutation.setLoadingNextPage(false))
            ])
            
        case let .didTapFavoriteButton(index):
            return Observable.just(Mutation.toggleFavoriteState(index: index))
        }
    }
}

private extension HomeViewReactor {
    func toggleFavoriteState(previousState: State, index: Int) -> Movie {
        var movie = previousState.movies[index]
        
        movie.isFavorite.toggle()
        movie.favoriteRegistrationTime = movie.isFavorite ? Date() : nil
        
        useCase.updateFavoriteMovies(movie)
        
        return movie
    }
    
    // 서버에서 가져오는 행위를 한번만 하기위해(비용 감소) 기존 State와 비교하여 데이터를 내려줌 -> 즐겨찾기의 상태는 어느 뷰에서든 가능하기 때문에 항시 찜목록은 가져와야함
    func updateMovies(previousState: State, favoriteMovies: [Movie]) -> [Movie] {
        let favoriteMoviesId = favoriteMovies.map { $0.id }
        
        return previousState.movies.map {
            var movie = $0
            movie.isFavorite = favoriteMoviesId.contains(movie.id)
            
            return movie
        }
    }
}

extension HomeViewReactor.Action {
    // 새로 fetchMvoies Action이 들어올 때 기존에 업데이트 하고 있는 걸 취소할 때 쓰임
    static func isUpdate(_ action: HomeViewReactor.Action) -> Bool {
        if case .fetchMovies = action {
            return true
        } else {
            return false
        }
    }
}
