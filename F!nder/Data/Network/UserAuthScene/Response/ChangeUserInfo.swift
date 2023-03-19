//
//  ChangeUserInfo.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/24.
//

import Foundation

struct ChangeUserInfoResponse : Codable {
    let success: Bool
    let response: ChangeUserInfoSuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct ChangeUserInfoSuccessResponse : Codable {
    let mbti: String
    let nickname: String
}
