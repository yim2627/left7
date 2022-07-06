//
//  Product.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import Foundation

struct Product: Hashable {
    let id: Int
    let name: String
    let thumbnailPath: String
    let descriptionImagePath: String
    let descriptionSubject: String
    let price: Int
    let rate: Double
    var isFavorite: Bool
    var favoriteRegistrationTime: Date?
}
