//
//  StubURLSessionDataTask.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation
@testable import Left7

final class StubURLSessionDataTask: URLSessionDataTask {
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
    
    override func cancel() {}
}
