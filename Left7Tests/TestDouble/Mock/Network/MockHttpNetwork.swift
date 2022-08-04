//
//  MockHttpNetwork.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/07.
//

import XCTest
@testable import Left7

import RxSwift

extension EndPoint: Equatable {
    public static func == (lhs: EndPoint, rhs: EndPoint) -> Bool {
        return lhs.url == rhs.url
    }
}

final class MockHttpNetwork: HttpNetworkType  {
    private var data: Data
    
    private var endPoint: EndPoint?
    private var callCount: Int = 0
    
    init(data: Data) {
        self.data = data
    }
    
    func fetch(endPoint: EndPoint) -> Observable<Data> {
        self.endPoint = endPoint
        self.callCount += 1
        
        return Observable.just(data)
    }
    
    func verifyFetch(endPoint: EndPoint, callCount: Int = 1) {
        XCTAssertEqual(self.endPoint, endPoint)
        XCTAssertEqual(self.callCount, callCount)
    }
}
