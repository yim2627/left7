//
//  ProductDescriptionResponse.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct ProductDescriptionResponse: Decodable {
    let imagePath: String
    let subject: String
    let price: Int
}
