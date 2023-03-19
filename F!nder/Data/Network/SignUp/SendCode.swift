//
//  SendCode.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/26.
//

import Foundation

struct SendCode {
    let code: String
    let email: String
    var parameters : [String: String] { [
        "code": code,
        "email": email
    ]}
}

struct SendCodeResponse: Codable {
    let success : Bool
    let response : SendCodeSuccessResponse?
    let errorResponse : ErrorReponseDTO?
}

struct SendCodeSuccessResponse : Codable {
    let message: String
}
