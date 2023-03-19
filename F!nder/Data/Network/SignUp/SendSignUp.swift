//
//  SendSignUp.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/30.
//

import Foundation

struct SendSignUp {
    let email: String
    let password: String
    let mbti: String
    let nickname: String
    
    var parameters : [String: String] { [
        "email": email,
        "password": password,
        "mbti": mbti,
        "nickname": nickname,
    ]}
}

struct SignUpResponse : Codable {
    let success: Bool
    let response: SignUpSuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct SignUpSuccessResponse: Codable {
    let grantType: String
    let accessToken: String
    let accessTokenExpireTime: String
    let refreshToken: String
    let refreshTokenExpireTime: String
}
