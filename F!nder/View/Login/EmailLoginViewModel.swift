//
//  EmailLoginViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2022/08/09.
//

import Foundation

import ReactorKit
import RxSwift

class EmailLoginViewModel : Reactor {
    
    let initialState: State
    var loginRequest: SendLogin
    let userAuthRepository = UserAuthRepository.shared
    let userAPI = UserInfoAPI()
    
    init() {
        self.initialState = State(userToken: "", errorMessage: "")
        self.loginRequest = SendLogin(email: "", password: "")
    }
    
    enum Action {
        case IdTextFieldIsFilled
        case passwordTextFieldIsFilled
        case tapLoginButton(String,String)
    }
    
    enum Mutation {
        case isIdTextFieldFilled(Bool)
        case isPasswordTextFieldFilled(Bool)
//        case setUserLoginInfo
        case loginFail(String)
        case loginSuccess(String)
    }
    
    func mutate(action: EmailLoginViewModel.Action) -> Observable<Mutation> {
        switch action {
        case .IdTextFieldIsFilled:
            return Observable.just(.isIdTextFieldFilled(true))
        case .passwordTextFieldIsFilled:
            return Observable.just(.isPasswordTextFieldFilled(false))
        case .tapLoginButton(let id, let password):

            self.loginRequest.email = id
            self.loginRequest.password = password

            let loginResult = self.userAuthRepository.loginUserServer(loginRequest: self.loginRequest)
            
            return loginResult.map({ loginBase -> Mutation in
                if loginBase.success {
//                    return Observable.concat([
//                        Observable.just()
//                    ])
                    return .loginSuccess(loginBase.response?.accessToken ?? "nil")
                } else {
                    return .loginFail(loginBase.errorResponse?.errorMessages[0] ?? "nil")
                }
            })
        }
    }
    
    func reduce(state: EmailLoginViewModel.State, mutation: EmailLoginViewModel.Mutation) -> EmailLoginViewModel.State {
        var newState = state
        
        switch mutation {
            
        case .isIdTextFieldFilled(_):
            newState.isIdTextFieldFilled = true
            if newState.isPasswordTextFieldFilled && newState.isIdTextFieldFilled {
                newState.isLoginButtonEnabled = true
            } else {
                newState.isLoginButtonEnabled = false
            }
        case .isPasswordTextFieldFilled(_):
            
            newState.isPasswordTextFieldFilled = true
            if newState.isPasswordTextFieldFilled && newState.isIdTextFieldFilled {
                newState.isLoginButtonEnabled = true
            } else {
                newState.isLoginButtonEnabled = false
            }
            
        case .loginSuccess(let token) :
            newState.isLoginSuccess = true
            newState.userToken = token
        case .loginFail(let errorMessage):
            newState.isLoginFail = true
            newState.errorMessage = errorMessage
//        case .setUserLoginInfo:
//            newState.
        }
        return newState
    }
    
    struct State {
        var isIdTextFieldFilled: Bool = false
        var isPasswordTextFieldFilled: Bool = false
        var isLoginButtonEnabled: Bool = false
        @Pulse var didTapLoginButton: Bool = false
        
        var isLoginSuccess: Bool = false
        var isLoginFail:Bool = false
        var userToken:String = ""
        var errorMessage:String = ""
    }
    
    // TODO : 추후 수정
    func getServiceTermViewmodelForCreatingTask() -> EmailLoginViewModel {
        return EmailLoginViewModel()
    }
}
