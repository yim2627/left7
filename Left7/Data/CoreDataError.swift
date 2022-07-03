//
//  CoreDataError.swift
//  Left7
//
//  Created by 임지성 on 2022/07/04.
//

import Foundation

enum CoreDataError: String, LocalizedError {
    case FetchFail = "ERROR: CoreData Fetch Fail"
    case SaveFail = "ERROR: CoreData Save Fail"
    
    var errorDescription: String {
        return self.rawValue
    }
}   
