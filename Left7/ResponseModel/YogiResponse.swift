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
    let productData: [ProductDataResponse]
    
    enum CodingKeys: String, CodingKey {
        case statusMsg = "msg"
        case statusCode = "code"
        case productData = "data"
    }
}
