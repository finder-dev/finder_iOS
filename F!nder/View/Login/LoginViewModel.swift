//
//  LoginViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2022/08/08.
//

import Foundation

import ReactorKit
import RxSwift

class LoginViewModel: Reactor {
    
    var initialState: State
    
    init() {
        self.initialState = State()
    }
    enum Action {
        case emailLogin
    }
    
    enum Mutation {
        case setIsPresentEmailLogin(Bool)
    }
    
    func mutate(action: LoginViewModel.Action) -> Observable<Mutation> {
        
        switch action {
        case .emailLogin:
            return Observable.concat([
                Observable.just(.setIsPresentEmailLogin(true)),
                Observable.just(.setIsPresentEmailLogin(false))
            ])
        }
    }
    
    struct State {
        var isPresentEditTask: Bool = false
    }
    
    func reduce(state: LoginViewModel.State, mutation: LoginViewModel.Mutation) -> LoginViewModel.State {
        
        var newState = state
        
        switch mutation {
        case .setIsPresentEmailLogin(let isPresent):
            newState.isPresentEditTask = isPresent
        }
        
        return newState
    }
    
    func getEmailLoginViewmodelForCreatingTask() -> EmailLoginViewModel {
        
        return EmailLoginViewModel()
    }
}
