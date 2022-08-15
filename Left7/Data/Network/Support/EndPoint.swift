//
//  EndPoint.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

struct EndPoint {
    
    //MARK: - Properties

    private let baseURL: String
    private let urlInformation: URLInformation
    private let queryParameters: Encodable?
    
    //MARK: - Init

    init(
        baseURL: String = "https://api.themoviedb.org/3",
        urlInformation: URLInformation,
        queryParameters: Encodable?
    ) {
        self.baseURL = baseURL
        self.urlInformation = urlInformation
        self.queryParameters = queryParameters
    }
    
    //MARK: - Function
    
    func generateURL() -> Result<URL, HttpNetworkError> {
        guard var urlComponents = URLComponents(string: baseURL + urlInformation.path) else {
            return .failure(.invalidURLComponents)
        }
        
        var urlQueryParams: [URLQueryItem] = []
        if let queryParameters = queryParameters?.toDictionary() {
            switch queryParameters {
            case .success(let data):
                data.forEach {
                    urlQueryParams.append(
                        URLQueryItem(
                            name: $0.key,
                            value: "\($0.value)"
                        )
                    )
                }
            case .failure(let error):
                return .failure(error)
            }
        }
        
        urlComponents.queryItems = urlQueryParams.isEmpty ? nil : urlQueryParams
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        return .success(url)
    }
}

extension EndPoint {
    enum URLInformation {
        case nowPlayingList
        
        var path: String {
            switch self {
            case .nowPlayingList:
                return "/movie/now_playing"
            }
        }
    }
}

extension Encodable {
    func toDictionary() -> Result<[String: Any], HttpNetworkError> {
        do {
            let jsonString = try JSONEncoder().encode(self)
            guard let json = try JSONSerialization.jsonObject(with: jsonString) as? [String: Any] else {
                return .failure(.decodeError)
            }
            return .success(json)
        } catch {
            return .failure(.decodeError)
        }
    }
}
