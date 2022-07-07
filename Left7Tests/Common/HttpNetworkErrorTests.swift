//
//  HttpNetworkErrorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class HttpNetworkErrorTests: XCTestCase {
    private enum TestError: LocalizedError {
        case dummyError
        
        var errorDescription: String? {
            switch self {
            case .dummyError:
                return "err"
            }
        }
    }
    
    func test_HttpNetworkError() {
        XCTAssertEqual(HttpNetworkError.invalidURL.errorDescription, "ERROR: Invalid URL")
        XCTAssertEqual(HttpNetworkError.invalidResponse.errorDescription, "ERROR: Invalid Response")
        XCTAssertEqual(HttpNetworkError.unknownError(TestError.dummyError).errorDescription, "ERROR: Unknown Error - err")
        XCTAssertEqual(HttpNetworkError.abnormalStatusCode(400).errorDescription, "ERROR: Abnormal Status Code 400")
    }
}
