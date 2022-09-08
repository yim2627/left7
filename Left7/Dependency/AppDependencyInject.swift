//
//  AppDependencyInject.swift
//  Left7
//
//  Created by 임지성 on 2022/09/07.
//

import Foundation
import Swinject

final class AppDependencyInject {
	private init() { }
	
	static let rootContainer: Container = {
		let container = Container()
		let assembler = Assembler([
			HomeViewReactorAssembly(),
			DetailViewReactorAssembly(),
			FavoriteViewReactorAssembly(),
			UseCaseAssembly(),
			RepositoryAssembly()
		], container: container)
		// 인스턴스 생성후 run 메서드를 타며 각 assembly의 assemble 메서드 전부 실행하여 의존성 주입
		
		return container
	}()
}
