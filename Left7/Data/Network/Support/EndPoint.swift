//
//  EndPoint.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct EndPoint {
    private let urlInformation: URLInformation
    private let scheme: String = "http"
    private let host: String = "www.gccompany.co.kr"
    
    init(urlInformation: URLInformation) {
        self.urlInformation = urlInformation
    }
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = urlInformation.path
        
        return components.url
    }
    
    enum URLInformation {
        case pagination(jsonId: Int)
        
        var path: String {
            switch self {
            case .pagination(let jsonId):
                return "/App/json/\(jsonId).json"
            }
        }
    }
}
