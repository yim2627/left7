//
//  DetailViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift

import ReactorKit

protocol DetailViewReactorDependencyType: AnyObject {
	var useCase: DetailUseCaseType { get }
}

final class DetailViewReactorDependency: DetailViewReactorDependencyType {
	let useCase: DetailUseCaseType
	
	init(useCase: DetailUseCaseType) {
		self.useCase = useCase
	}
}

final class DetailViewReactor: Reactor {
	//MARK: - Properties
	
	private let dependency: DetailViewReactorDependencyType
	var initialState: State
	
	//MARK: - Init
	
	init(dependency: DetailViewReactorDependencyType, selectedMovie: Movie?) {
		self.dependency = dependency
		self.initialState = State(movie: selectedMovie)
	}
	
	//MARK: - Model
	
	enum Action {
		case didTapFavoriteButton
	}
	
	enum Mutation {
		case toggleFavoriteState
	}
	
	struct State {
		var movie: Movie?
	}
	
	//MARK: - Reduce
	
	func reduce(state: State, mutation: Mutation) -> State {
		switch mutation {
			case .toggleFavoriteState:
				var newState = state
				let updatedMovie = toggleFavoriteState(previousState: state)
				newState.movie = updatedMovie
				
				return newState
		}
	}
	
	//MARK: - Mutate
	
	func mutate(action: Action) -> Observable<Mutation> {
		switch action {
			case .didTapFavoriteButton:
				return Observable.just(Mutation.toggleFavoriteState)
		}
	}
}

private extension DetailViewReactor {
	func toggleFavoriteState(previousState: State) -> Movie {
		guard var movie = previousState.movie else {
			return .empty
		}
		
		movie.isFavorite.toggle()
		movie.favoriteRegistrationTime = movie.isFavorite ? Date() : nil
		
		dependency.useCase.updateFavoriteMovie(movie)
		
		return movie
	}
}
