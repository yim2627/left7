//
//  Movie.swift
//  Left7
//
//  Created by 임지성 on 2022/07/02.
//

import Foundation

struct Movie: Hashable {
    static let empty: Self = .init(
        id: -1,
        name: "",
        posterPath: "",
        descriptionSubject: "",
        rate: -1,
        isFavorite: false,
        favoriteRegistrationTime: nil
    )
    
    let id: Int
    let name: String
    let posterPath: String
    let descriptionSubject: String
    let rate: Double
    var isFavorite: Bool
    var favoriteRegistrationTime: Date?
}
