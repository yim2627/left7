//
//  HomeDataSection.swift
//  Left7
//
//  Created by 임지성 on 2022/09/13.
//

import Foundation
import RxDataSources

struct HomeDataSection {
	var items: [Movie]
}

extension HomeDataSection: SectionModelType {
	typealias Item = Movie
	
	init(original: HomeDataSection, items: [Item]) {
		self = original
		self.items = items
	}
}
