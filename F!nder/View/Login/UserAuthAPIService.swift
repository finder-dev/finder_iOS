//
//  UserAuthAPIService.swift
//  F!nder
//
//  Created by 장선영 on 2022/08/09.
//

import Foundation
import Moya
import RxMoya

enum UserAuthAPIService {
    case login(loginRequest: SendLogin)
}
//https://finder777.com/api/login
extension UserAuthAPIService : TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://finder777.com") else {
            fatalError()
        }
        return url
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let loginRequest):
            return .requestData(loginRequest.parameters.percentEncoded()!)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
             return nil
        }
    }
    
    
}

