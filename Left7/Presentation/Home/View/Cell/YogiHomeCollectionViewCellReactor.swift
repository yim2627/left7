//
//  YogiHomeCollectionViewCellReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/06.
//

import Foundation

import RxSwift
import RxCocoa

import ReactorKit

final class YogiHomeCollectionViewCellReactor: Reactor {
    typealias Action = NoAction
    
    var initialState: State
    
    struct State {
        var product: Product?
    }
    
    init(state: State) {
        self.initialState = state
    }
}
