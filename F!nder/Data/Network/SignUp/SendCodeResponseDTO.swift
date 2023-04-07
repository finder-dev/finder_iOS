//
//  SendCode.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/26.
//

import Foundation

// MARK: - Data Transfer Object

struct SendCodeResponseDTO: Codable {
    let success: Bool
    let response: SendCodeSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct SendCodeSuccessDTO: Codable {
    let message: String
}

struct SendCode {
    let code: String
    let email: String
    var parameters : [String: String] { [
        "code": code,
        "email": email
    ]}
}
