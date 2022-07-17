//
//  MakeDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct MakeDebate {
    let title: String
    let optionA: String
    let optionB: String
    
    var parameters : [String: String] { [
        "title": title,
        "optionA": optionA,
        "optionB": optionB
    ]}
}

struct MakeDebateResponse : Codable {
    let success: Bool
    let response: MakeDebateSuccessResponse?
    let errorResponse: MakeDebateErrorResponse?
}

struct MakeDebateSuccessResponse : Codable {
    let debateId: Int
}

struct MakeDebateErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
