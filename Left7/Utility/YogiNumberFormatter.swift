//
//  YogiNumberFormatter.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

final class YogiNumberFormatter {
    static let shared = YogiNumberFormatter()
    
    private init() { }
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        return formatter
    }()
    
    func toString(number: Int) -> String {
        return numberFormatter.string(for: number) ?? ""
    }
}
