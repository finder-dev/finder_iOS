//
//  UserInfo.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct UserInfoResponse : Codable {
    let success: Bool
    let response: UserInfoSuccessResponse?
    let errorResponse: UserInfoErrorResponse?
}

struct UserInfoSuccessResponse : Codable {
    let userId: Int
    let email: String
    let mbti: String
    let nickname: String
}

struct UserInfoErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
