//
//  UserAuthRepository.swift
//  F!nder
//
//  Created by 장선영 on 2022/08/09.
//

import Foundation
import RxSwift
import RxMoya
import Moya

final class UserAuthRepository : NSObject {
    
    static let shared = UserAuthRepository()
    private var disposeBag = DisposeBag()
    
    private override init() {
        super.init()
    }
    
    private let userAuthProvider = MoyaProvider<UserAuthAPIService>()
    
    // 로그인
    func loginUserServer(loginRequest: SendLogin) -> Observable<LoginResponse> {
        print("loginUserServer :\(loginRequest)")
        return userAuthProvider.rx.request(.login(loginRequest: loginRequest))
            .map(LoginResponse.self)
            .asObservable()
            .do(onError: { print("Error = \($0)") })
    }
    
}
