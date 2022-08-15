//
//  Left7Tests.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/06.
//

import XCTest
@testable import Left7

class EndPointTests: XCTestCase {
    func test_Page_EndPoint() {
        let queryParams = NowPlayingRequestModel(
            apiKey: "13002531cbc59fc376da2b25a2fb918a",
            page: 1)
        let endPoint = EndPoint(
            urlInformation: .nowPlayingList,
            queryParameters: queryParams
        ).generateURL()
        
        switch endPoint {
        case .success(let url):
            XCTAssertEqual(url, URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=13002531cbc59fc376da2b25a2fb918a&page=1"))
        case .failure(_):
            XCTFail()
        }
    }
}
