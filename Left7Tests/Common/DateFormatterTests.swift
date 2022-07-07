//
//  DateFormatterTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

final class DateFormatterTests: XCTestCase {
    func test_toDateString() {
        let dateFormatter = YogiDateFormatter.shared
        
        let testDate = Date(timeIntervalSince1970: 10000) // 1970/01/01 11:46
        
        XCTAssertEqual(dateFormatter.toDateString(date: testDate), "1970/01/01 11:46")
    }
}
