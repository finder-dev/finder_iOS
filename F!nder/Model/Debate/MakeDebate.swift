//
//  MakeDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

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
