//
//  HttpMethodTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

class HttpMethodTests: XCTestCase {
    func test_HttpMethod() {
        XCTAssertEqual(HttpMethod.get.rawValue, "GET")
    }
}
