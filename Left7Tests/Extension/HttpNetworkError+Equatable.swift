//
//  HttpNetworkError+Equatable.swift
//  Left7Tests
//
//  Created by 임지성 on 2022/07/08.
//

import XCTest
@testable import Left7

extension HttpNetworkError: Equatable {
    public static func == (
        lhs: HttpNetworkError,
        rhs: HttpNetworkError
    ) -> Bool {
        return lhs.errorDescription == rhs.errorDescription
    }
}

