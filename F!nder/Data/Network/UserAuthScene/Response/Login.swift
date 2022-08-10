//
//  Login.swift
//  F!nder
//
//  Created by 장선영 on 2022/08/09.
//

import Foundation

struct SendLogin {
    var email: String
    var password: String
    
    var parameters : [String: String] { [
        "email": email,
        "password": password
    ]}
}

struct LoginResponse : Codable {
    let success: Bool
    let response: LoginSuccessResponse?
    let errorResponse: LoginErrorResponse?
}

struct LoginSuccessResponse: Codable {
    let grantType: String
    let accessToken: String
    let accessTokenExpireTime: String
    let refreshToken: String
    let refreshTokenExpireTime: String
}

struct LoginErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
