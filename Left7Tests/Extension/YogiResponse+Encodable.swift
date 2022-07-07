//
//  YogiResponse+Encodable.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

@testable import Left7

extension YogiResponse: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(statusMsg, forKey: .statusMsg)
        try container.encode(statusCode, forKey: .statusCode)
        try container.encode(productData, forKey: .productData)
    }
}

extension YogiResponse.ProductDataResponse: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(productTotalCount, forKey: .productTotalCount)
        try container.encode(products, forKey: .products)
    }
}

extension YogiResponse.ProductDataResponse.ProductResponse: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(thumbnailPath, forKey: .thumbnailPath)
        try container.encode(description, forKey: .description)
        try container.encode(rate, forKey: .rate)
    }
}

extension YogiResponse.ProductDataResponse.ProductResponse.ProductDescriptionResponse: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(imagePath, forKey: .imagePath)
        try container.encode(subject, forKey: .subject)
        try container.encode(price, forKey: .price)
    }
    
    enum CodingKeys: String, CodingKey {
        case imagePath
        case subject
        case price
    }
}
