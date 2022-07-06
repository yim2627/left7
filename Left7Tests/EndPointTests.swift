//
//  Left7Tests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

class Left7Tests: XCTestCase {
    func test_Page1_EndPoint가_정상적으로_나오는지() {
        let endPoint = EndPoint(urlInformation: .pagination(page: 1))
        XCTAssertEqual(endPoint.url, URL(string: "http://www.gccompany.co.kr/App/json/1.json"))
    }
    
    func test_Page2_EndPoint가_정상적으로_나오는지() {
        let endPoint = EndPoint(urlInformation: .pagination(page: 2))
        XCTAssertEqual(endPoint.url, URL(string: "http://www.gccompany.co.kr/App/json/2.json"))
    }
    
    func test_Page3_EndPoint가_정상적으로_나오는지() {
        let endPoint = EndPoint(urlInformation: .pagination(page: 3))
        XCTAssertEqual(endPoint.url, URL(string: "http://www.gccompany.co.kr/App/json/3.json"))
    }
}
