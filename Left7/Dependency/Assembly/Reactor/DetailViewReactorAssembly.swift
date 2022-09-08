//
//  DetailViewReactorAssembly.swift
//  Left7
//
//  Created by 임지성 on 2022/09/08.
//

import Foundation
import Swinject

final class DetailViewReactorAssembly: Assembly {
	func assemble(container: Container) {
		container.register(DetailViewReactorDependencyType.self) { r in
			return DetailViewReactorDependency(useCase: r.resolve(DetailUseCaseType.self)!)
		}
	}
}
