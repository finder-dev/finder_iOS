//
//  SendEmail.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/26.
//

import Foundation

struct SendEmailResponse: Codable {
    let success : Bool
    let response : SendEmailSuccessResponse?
    let errorResponse : ErrorReponseDTO?

struct SendEmailSuccessResponse : Codable {
    let message: String
}

struct SendEmail : Codable {
    let email : String
    var parameters : [String: String] { [
        "email": email
    ]
    }
}
