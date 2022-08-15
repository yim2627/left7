//
//  DefaultRequester.swift
//  Left7
//
//  Created by 임지성 on 2022/08/15.
//

import Foundation

final class DefaultRequester: Requsetable {
    func retrieveDataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: urlRequest, completionHandler: completionHandler)
    }
}
