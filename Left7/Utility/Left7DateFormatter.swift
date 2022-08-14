//
//  Left7DateFormatter.swift
//  Left7
//
//  Created by 임지성 on 2022/07/05.
//

import Foundation

final class Left7DateFormatter { // UIComponent에 값을 할당할 때마다 인스턴스를 생성하면 메모리적으로 문제가 생길 것 같아 싱글턴으로 적용 -> 싱글턴의 장점은? 최초 한번의 인스턴스 생성시 static 메서드를 통해 고정된 메모리 공간을 사용하고, 사용 후 이미 생성된 인스턴스를 사용하기 때문에 속도 측면에서 이점을 가진다. 싱글턴의 문제점은? 사용하는 곳이 많을 경우 다른 타입들간의 의존성이 높아져 테스트가 어렵다는 단점을 가진다.
    static let shared = Left7DateFormatter()
    
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
