//
//  StubURLSession.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

final class StubRequesterWithStatusCode: Requsetable {
    private let isSuccess: Bool
    
    init(isSuccess: Bool = true) {
        self.isSuccess = isSuccess
    }
    
    func retrieveDataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(
            url: urlRequest.url!,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: nil
        )
        
        let failureResponse = HTTPURLResponse(
            url: urlRequest.url!,
            statusCode: 400,
            httpVersion: "1.1",
            headerFields: nil
        )
        
        let dataString = #""OK""#
        let data = dataString.data(using: .utf8)!
        
        let sessionDataTask = StubURLSessionDataTask()
        
        if isSuccess {
            sessionDataTask.resumeDidCall = {
                completionHandler(data, successResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        
        return sessionDataTask
    }
}
