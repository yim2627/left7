//
//  EndPointStorage.swift
//  Left7
//
//  Created by 임지성 on 2022/08/15.
//

import Foundation

struct EndPointStorage {
    static func movieList(page: Int) -> EndPoint {
        let endPoint = EndPoint(
            urlInformation: .nowPlayingList,
            queryParameters: NowPlayingRequestModel(
                apiKey: "13002531cbc59fc376da2b25a2fb918a",
                page: page
            )
        )
        
        return endPoint
    }
}

struct NowPlayingRequestModel: Encodable {
    let apiKey: String
    let page: Int
    
    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case page
    }
}
