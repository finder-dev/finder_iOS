//
//  VoteDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

struct VoteDebateResponse : Codable {
    let success: Bool
    let response: VoteDebateSuccessResponse?
    let errorResponse: VoteDebateErrorResponse?
}

struct VoteDebateSuccessResponse : Codable {
    let message: String
    let option:String
}

struct VoteDebateErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
