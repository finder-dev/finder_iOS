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
    case getUserInfo
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
        case .getUserInfo:
            return "/api/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let loginRequest):
            return .requestData(loginRequest.parameters.percentEncoded()!)
        case .getUserInfo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .login:
             return nil
        case .getUserInfo:
            guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
                print("오류 : token 없음")
                return nil
            }
            return ["Authorization" : "Bearer +\(token)"]
        }
    }
    
    
}

