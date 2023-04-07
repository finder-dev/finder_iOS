//
//  SendSignUp.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/30.
//

import Foundation

// MARK: - Data Transfer Object

struct SignUpResponseDTO: Codable {
    let success: Bool
    let response: SignUpSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct SignUpSuccessDTO: Codable {
    let grantType: String
    let accessToken: String
    let accessTokenExpireTime: String
    let refreshToken: String
    let refreshTokenExpireTime: String
}

struct SendSignUp {
    let email: String
    let password: String
    let mbti: String
    let nickname: String
    
    var parameters: [String: String] { [
        "email": email,
        "password": password,
        "mbti": mbti,
        "nickname": nickname,
    ]}
}
