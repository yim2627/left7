//
//  ProductDataResponse.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct ProductDataResponse: Decodable {
    let productTotalCount: Int
    let product: [ProductResponse]
    
    enum CodingKeys: String, CodingKey {
        case productTotalCount = "totalCount"
        case product
    }
}
