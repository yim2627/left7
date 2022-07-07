//
//  CoreDataErrorTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

class CoreDataErrorTests: XCTestCase {
    func test_CoreDataError() {
        XCTAssertEqual(CoreDataError.FetchFail.errorDescription, "ERROR: CoreData Fetch Fail")
        XCTAssertEqual(CoreDataError.SaveFail.errorDescription, "ERROR: CoreData Save Fail")
    }
}
