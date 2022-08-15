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
    var stubRequester: Requsetable!
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
        stubRequester = StubRequesterWithStatusCode()
        sut = HttpNetwork(requester: stubRequester)
        
        var resultOfTask: String?
        let url = try! EndPoint(urlInformation: .nowPlayingList).generateURL().get()
        
        let expectation = XCTestExpectation(description: "Success")
        
        sut.fetch(with: url)
            .subscribe(onNext: {
                resultOfTask = String(data: $0, encoding: .utf8)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(resultOfTask, #""OK""#)
    }
    
    func test_FailureCase_with_Abnormal_StatusCode() {
        stubRequester = StubRequesterWithStatusCode(isSuccess: false)
        sut = HttpNetwork(requester: stubRequester)
    
        let url = try! EndPoint(urlInformation: .nowPlayingList).generateURL().get()
        
        let expectation = XCTestExpectation(description: "Fail")
        
        sut.fetch(with: url)
            .subscribe(onError: {
                let statusError = HttpNetworkError.abnormalStatusCode(400)
                XCTAssertEqual($0 as? HttpNetworkError, statusError)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FailureCase_with_InvalidResponse_data() {
        stubRequester = StubRequesterWithInvalidResponse(errorKind: .data)
        sut = HttpNetwork(requester: stubRequester)
    
        let url = try! EndPoint(urlInformation: .nowPlayingList).generateURL().get() // 임시
        
        let expectation = XCTestExpectation(description: "Invalid Response with Data")
        
        sut.fetch(with: url)
            .subscribe(onError: {
                let error = HttpNetworkError.invalidResponse
                XCTAssertEqual($0 as? HttpNetworkError, error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_FailureCase_with_InvalidResponse_empty() {
        stubRequester = StubRequesterWithInvalidResponse(errorKind: .emptyResponse)
        sut = HttpNetwork(requester: stubRequester)
    
        let url = try! EndPoint(urlInformation: .nowPlayingList).generateURL().get() // 임시
        
        let expectation = XCTestExpectation(description: "Empty Respones")
        
        sut.fetch(with: url)
            .subscribe(onError: {
                let error = HttpNetworkError.invalidResponse
                XCTAssertEqual($0 as? HttpNetworkError, error)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
            
        
        wait(for: [expectation], timeout: 5.0)
    }
}
