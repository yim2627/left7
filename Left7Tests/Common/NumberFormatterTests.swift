//
//  NumberFormatterTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class NumberFormatterTests: XCTestCase {
    func test_toString() {
        let numberFormatter = YogiNumberFormatter.shared
        
        XCTAssertEqual(numberFormatter.toString(number: 1000), "1,000")
    }
}
