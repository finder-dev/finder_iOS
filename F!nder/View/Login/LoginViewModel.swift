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
        case showServiceTerm
    }
    
    enum Mutation {
        case setIsPresentEmailLogin(Bool)
        case setIsPresentServiceTerm(Bool)
    }
    
    func mutate(action: LoginViewModel.Action) -> Observable<Mutation> {
        
        switch action {
        case .emailLogin:
            return Observable.concat([
                Observable.just(.setIsPresentEmailLogin(true)),
                Observable.just(.setIsPresentEmailLogin(false))
            ])
        case .showServiceTerm:
            return Observable.concat([
                Observable.just(.setIsPresentServiceTerm(true)),
                Observable.just(.setIsPresentServiceTerm(false))
            ])
        }
    }
    
    struct State {
        var isPresentEditTask: Bool = false
        var isPresentServiceTerm: Bool = false
    }
    
    func reduce(state: LoginViewModel.State, mutation: LoginViewModel.Mutation) -> LoginViewModel.State {
        
        var newState = state
        
        switch mutation {
        case .setIsPresentEmailLogin(let isPresent):
            newState.isPresentEditTask = isPresent
        case .setIsPresentServiceTerm(let isPresent):
            newState.isPresentServiceTerm = isPresent
        }
        return newState
    }
    
    // TODO : 추후 수정
    func getEmailLoginViewmodelForCreatingTask() -> EmailLoginViewModel {
        return EmailLoginViewModel()
    }
    // TODO : 추후 수정
    func getServiceTermViewmodelForCreatingTask() -> EmailLoginViewModel {
        return EmailLoginViewModel()
    }
    
}
