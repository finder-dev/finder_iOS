//
//  SendSocialLogin.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/29.
//

import Foundation

struct SendSocialLogin {
    let userType: String
    let mbti: String
    let nickname: String
    
    var parameters : [String: String] { [
        "userType": userType,
        "mbti": mbti,
        "nickname": nickname,
    ]}
}

struct SocialLoginResponse : Codable {
    let success: Bool
    let response: SocialLoginSuccessResponse?
    let errorResponse: SocailLoginErrorResponse?
}

struct SocialLoginSuccessResponse: Codable {
    let grantType: String
    let accessToken: String
    let accessTokenExpireTime: String
    let refreshToken: String
    let refreshTokenExpireTime: String
}

struct SocailLoginErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
