//
//  URLSessionProtocol.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

protocol Requsetable {
    func retrieveDataTask(
        with urlRequest: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    -> URLSessionDataTask
}

