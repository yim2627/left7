//
//  HttpNetworkError.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

enum HttpNetworkError: LocalizedError {
    case invalidResponse
    case invalidURL
    case invalidURLComponents
    case abnormalStatusCode(_ statusCode: Int)
    case unknownError(_ error: Error)
    case decodeError
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "ERROR: Invalid Response"
        case .invalidURL:
            return "ERROR: Invalid URL"
        case .invalidURLComponents:
            return "ERROR: Invalid URLComponents"
        case .abnormalStatusCode(let statusCode):
            return "ERROR: Abnormal Status Code \(statusCode)"
        case .unknownError(let error):
            return "ERROR: Unknown Error - \(error.localizedDescription)"
        case .decodeError:
            return "ERROR: Decode Error"
        }
    }
}
