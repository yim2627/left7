//
//  EndPoint.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct EndPoint {
    //MARK: - Properties

    private let urlInformation: URLInformation
    private let scheme: String = "http"
    private let host: String = "www.gccompany.co.kr"
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = urlInformation.path
        
        return components.url
    }
    
    //MARK: - Init

    init(urlInformation: URLInformation) {
        self.urlInformation = urlInformation
    }
    
    enum URLInformation {
        case pagination(page: Int)
        
        var path: String {
            switch self {
            case .pagination(let page):
                return "/App/json/\(page).json"
            }
        }
    }
}
