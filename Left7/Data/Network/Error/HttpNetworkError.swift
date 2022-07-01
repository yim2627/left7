//
//  HttpNetworkError.swift
//  Left7
//
//  Created by 임지성 on 2022/07/01.
//

import Foundation

enum HttpNetworkError: LocalizedError {
    case invalidRequest
    case invalidResponse
    case invalidURL
    case abnormalStatusCode(_ statusCode: Int)
    case unknownError(_ error: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidRequest:
            return "ERROR: Invalid Request"
        case .invalidResponse:
            return "ERROR: Invalid Response"
        case .invalidURL:
            return "ERROR: Invalid URL"
        case .abnormalStatusCode(let statusCode):
            return "ERROR: Abnormal Status Code \(statusCode)"
        case .unknownError(let error):
            return "ERROR: Unknown Error - \(error.localizedDescription)"
        }
    }
}
