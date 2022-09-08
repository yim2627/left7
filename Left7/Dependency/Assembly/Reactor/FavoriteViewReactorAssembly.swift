//
//  FavoriteViewAssembly.swift
//  Left7
//
//  Created by 임지성 on 2022/09/08.
//

import Foundation
import Swinject

final class FavoriteViewReactorAssembly: Assembly {
	func assemble(container: Container) {
		container.register(FavoriteViewReactorDependencyType.self) { r in
			return FavoriteViewReactorDependency(useCase: r.resolve(FavoriteUseCaseType.self)!)
		}
	}
}
