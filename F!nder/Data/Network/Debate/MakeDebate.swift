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
    let errorResponse: ErrorReponseDTO?
}

struct MakeDebateSuccessResponse : Codable {
    let debateId: Int
}
