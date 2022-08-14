//
//  HttpNetwork.swift
//  Left7
//
//  Created by 임지성 on 2022/06/17.
//

import Foundation
import RxSwift

protocol HttpNetworkType {
    func fetch(endPoint: EndPoint) -> Observable<Data>
}

final class HttpNetwork: HttpNetworkType {
    //MARK: - Properties

    private let session: URLSessionProtocol
    
    //MARK: - Init

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - Method

    func fetch(endPoint: EndPoint) -> Observable<Data> {
        guard let url = endPoint.url else {
            return .error(HttpNetworkError.invalidURL)
        }
        
        let urlRequest = URLRequest(url: URL(string: "https://api.themoviedb.org/3/movie/now_playing?page=1&api_key=13002531cbc59fc376da2b25a2fb918a")!, method: .get)
        
        return Observable<Data>.create { [weak self] emmiter in
            let task = self?.session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    emmiter.onError(HttpNetworkError.unknownError(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    emmiter.onError(HttpNetworkError.invalidResponse)
                    return
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    emmiter.onError(HttpNetworkError.abnormalStatusCode(httpResponse.statusCode))
                    return
                }
                
                guard let data = data else {
                    emmiter.onError(HttpNetworkError.invalidResponse)
                    return
                }
                
                emmiter.onNext(data)
                emmiter.onCompleted()
            }
            task?.resume()
            
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

private extension URLRequest {
    init(url: URL, method: HttpMethod) {
        self.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        self.httpMethod = method.rawValue
    }
}
