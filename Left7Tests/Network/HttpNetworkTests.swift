//
//  HttpNetworkTests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

import RxSwift


class HttpNetworkTests: XCTestCase {
    var sut: HttpNetwork!
    var stubURLSession: URLSessionProtocol!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        disposeBag = nil
    }
    
    func test_SuccessCase() {
        stubURLSession = StubURLSessionWithStatusCode()
        sut = HttpNetwork(session: stubURLSession)
        
        var resultOfTask: String?
        let endPoint = EndPoint(urlInformation: .pagination(page: 1))
        
        let expectation = XCTestExpectation(description: "Success")
        
        sut.fetch(endPoint: endPoint)
            .subscribe(onNext: {
                resultOfTask = String(data: $0, encoding: .utf8)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(resultOfTask, #""OK""#)
    }
    
    func test_FailureCase_with_Abnormal_StatusCode() {
        stubURLSession = StubURLSessionWithStatusCode(isSuccess: false)
        sut = HttpNetwork(session: stubURLSession)
    
        let endPoint = EndPoint(urlInformation: .pagination(page: 1))
        
        let expectation = XCTestExpectation(description: "Fail")
        
        sut.fetch(endPoint: endPoint)
            .subscribe(onError: {
                let statusError = HttpNetworkError.abnormalStatusCode(400)
                XCTAssertEqual($0 as? HttpNetworkError, statusError)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FailureCase_with_InvalidResponse_data() {
        stubURLSession = StubURLSessionWithInvalidResponse(errorKind: .data)
        sut = HttpNetwork(session: stubURLSession)
    
        let endPoint = EndPoint(urlInformation: .pagination(page: 1)) // 임시
        
        let expectation = XCTestExpectation(description: "Invalid Response with Data")
        
        sut.fetch(endPoint: endPoint)
            .subscribe(onError: {
                let error = HttpNetworkError.invalidResponse
                XCTAssertEqual($0 as? HttpNetworkError, error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FailureCase_with_InvalidResponse_empty() {
        stubURLSession = StubURLSessionWithInvalidResponse(errorKind: .emptyResponse)
        sut = HttpNetwork(session: stubURLSession)
    
        let endPoint = EndPoint(urlInformation: .pagination(page: 1)) // 임시
        
        let expectation = XCTestExpectation(description: "Empty Respones")
        
        sut.fetch(endPoint: endPoint)
            .subscribe(onError: {
                let error = HttpNetworkError.invalidResponse
                XCTAssertEqual($0 as? HttpNetworkError, error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
    }
}
