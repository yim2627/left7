//
//  ProductResponse.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct ProductResponse: Decodable {
    let id: Int
    let name: String
    let thumbnailPath: String
    let description: ProductDescriptionResponse
    let rate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, rate
        case thumbnailPath = "thumbnail"
    }
}


