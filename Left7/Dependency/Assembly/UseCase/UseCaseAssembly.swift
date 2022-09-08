//
//  UseCaseAssembly.swift
//  Left7
//
//  Created by 임지성 on 2022/09/08.
//

import Foundation
import Swinject

final class UseCaseAssembly: Assembly {
	func assemble(container: Container) {
		container.register(HomeUseCaseType.self) { r in
			return HomeUseCase(
				movieRepository: r.resolve(NetworkRepository.self)!,
				favoriteMovieRepository: r.resolve(CoreDataRepository.self)!
			)
		}
		
		container.register(DetailUseCaseType.self) { r in
			return DetailUseCase(favoriteMovieRepository: r.resolve(CoreDataRepository.self)!)
		}
		
		container.register(FavoriteUseCaseType.self) { r in
			return FavoriteUseCase(favoriteMovieRepository: r.resolve(CoreDataRepository.self)!)
		}
	}
}
