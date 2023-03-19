//
//  Logout.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct LogoutResponse : Codable {
    let success: Bool
    let response: LogoutSuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct LogoutSuccessResponse : Codable {
    let message: String
}
