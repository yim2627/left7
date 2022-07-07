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
    
    //MARK: - Properties

    var initialState: State
    
    //MARK: - Model

    struct State {
        var product: Product?
    }
    
    //MARK: - Init

    init(state: State) {
        self.initialState = state
    }
}
