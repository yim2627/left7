//
//  YogiHomeViewReactor.swift
//  Left7
//
//  Created by 임지성 on 2022/07/03.
//

import Foundation

import RxSwift
import RxCocoa

import ReactorKit

final class YogiHomeViewReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        
    }
    
    enum Mutate {
        
    }
    
    struct State {
        
    }
    
    func reduce(state: State, mutation: Action) -> State {
        return state
    }
    
    func mutate(action: Action) -> Observable<Action> {
        return .empty()
    }
}
