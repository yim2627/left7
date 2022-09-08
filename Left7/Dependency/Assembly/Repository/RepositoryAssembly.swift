//
//  RepositoryAssembly.swift
//  Left7
//
//  Created by 임지성 on 2022/09/08.
//

import Foundation
import Swinject

final class RepositoryAssembly: Assembly {
	func assemble(container: Container) {
		container.register(NetworkRepository.self) { r in
			return MovieRepository()
		}
		
		container.register(CoreDataRepository.self) { r in
			return FavoriteMovieRepository()
		}
	}
}

