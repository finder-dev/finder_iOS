//
//  SendSocialLogin.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/29.
//

import Foundation

// MARK: - Data Transfer Object

struct SocialLoginResponseDTO: Codable {
    let success: Bool
    let response: SocialLoginSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct SocialLoginSuccessDTO: Codable {
    let grantType: String
    let accessToken: String
    let accessTokenExpireTime: String
    let refreshToken: String
    let refreshTokenExpireTime: String
}

struct SendSocialLogin {
    let userType: String
    let mbti: String?
    let nickname: String?
    
    var parameters : [String: String?] { [
        "userType": userType,
        "mbti": mbti,
        "nickname": nickname,
    ]}
}
