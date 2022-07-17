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
    let errorResponse: LogoutErrorResponse?
}

struct LogoutSuccessResponse : Codable {
    let message: String
}

struct LogoutErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
