//
//  YogiDateFormatter.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

final class YogiDateFormatter {
    static let shared = YogiDateFormatter()
    
    private init() { }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter
    }()
    
    func toDateString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}
