//
//  FavoriteDataSection.swift
//  Left7
//
//  Created by 임지성 on 2022/09/13.
//

import Foundation
import RxDataSources

struct FavoriteDataSection {
	var items: [Movie]
}

extension FavoriteDataSection: SectionModelType {
	typealias Item = Movie
	
	init(original: FavoriteDataSection, items: [Movie]) {
		self = original
		self.items = items
	}
}
