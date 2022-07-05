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
    var initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var product: Product?
    }
    
    init(state: State) {
        self.initialState = state
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
}
