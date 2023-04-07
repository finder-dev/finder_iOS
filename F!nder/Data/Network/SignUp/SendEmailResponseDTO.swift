//
//  SendEmail.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/26.
//

import Foundation

// MARK: - Data Transfer Object

struct SendEmailResponseDTO: Codable {
    let success: Bool
    let response: SendEmailSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct SendEmailSuccessDTO: Codable {
    let message: String
}

struct SendEmail: Codable {
    let email: String
    var parameters: [String: String] { [
        "email": email
    ]
    }
}
