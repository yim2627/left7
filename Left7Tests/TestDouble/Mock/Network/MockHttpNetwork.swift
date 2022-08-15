//
//  MockHttpNetwork.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

final class MockHttpNetwork: HttpNetworkType  {
    var requester: Requsetable
    
    private var data: Data
    
    private var url: URL?
    private var callCount: Int = 0
    
    init(data: Data) {
        self.data = data
        self.requester = DummyRequester()
    }
    
    func fetch(with url: URL) -> Observable<Data> {
        self.url = url
        self.callCount += 1
        
        return Observable.just(data)
    }
    
    func verifyFetch(url: URL, callCount: Int = 1) {
        XCTAssertEqual(self.url, url)
        XCTAssertEqual(self.callCount, callCount)
    }
}

final class DummyRequester: Requsetable {
    func retrieveDataTask(with urlRequest: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession(configuration: .default).dataTask(with: urlRequest)
    }
}
