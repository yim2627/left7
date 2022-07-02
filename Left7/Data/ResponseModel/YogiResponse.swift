//
//  YogiResponse.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct YogiResponse: Decodable {
    let statusMsg: String
    let statusCode: Int
    let productData: ProductDataResponse
    
    enum CodingKeys: String, CodingKey {
        case statusMsg = "msg"
        case statusCode = "code"
        case productData = "data"
    }
}

extension YogiResponse {
    struct ProductDataResponse: Decodable {
        let productTotalCount: Int
        let product: [ProductResponse]
        
        enum CodingKeys: String, CodingKey {
            case productTotalCount = "totalCount"
            case product
        }
    }
}

extension YogiResponse.ProductDataResponse {
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
}

extension YogiResponse.ProductDataResponse.ProductResponse {
    struct ProductDescriptionResponse: Decodable {
        let imagePath: String
        let subject: String
        let price: Int
    }
}
