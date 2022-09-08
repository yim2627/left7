//
//  HomeViewReactorAssembly.swift
//  Left7
//
//  Created by 임지성 on 2022/09/08.
//

import Foundation
import Swinject

final class HomeViewReactorAssembly: Assembly {
	func assemble(container: Container) {
		container.register(HomeViewReactorDependencyType.self) { r in
			return HomeViewReactorDependency(useCase: r.resolve(HomeUseCaseType.self)!)
		}
	}
}
