//
//  StubURLSessionWithInvalidURL.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

final class StubURLSessionWithInvalidResponse: URLSessionProtocol {
    enum ResponseError {
        case data
        case emptyResponse
    }
    
    private let errorKind: ResponseError
    
    init(errorKind: ResponseError) {
        self.errorKind = errorKind
    }
    
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        let failureResponseWithData = HTTPURLResponse(
            url: URL(string: "1")!,
            statusCode: 200,
            httpVersion: "1.1",
            headerFields: nil
        )
        
        let sessionDataTask = StubURLSessionDataTask()
        
        switch errorKind {
        case .data:
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponseWithData, nil)
            }
        case .emptyResponse:
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, nil, nil)
            }
        }
        
        return sessionDataTask
    }
}
