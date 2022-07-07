//
//  CoreDataError.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

enum CoreDataError: LocalizedError {
    case FetchFail
    case SaveFail
    
    var errorDescription: String? {
        switch self {
        case .FetchFail:
            return "ERROR: CoreData Fetch Fail"
        case .SaveFail:
            return "ERROR: CoreData Save Fail"
        }
    }
}   
