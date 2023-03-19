//
//  HotDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct HotDebateResponse : Codable {
    let success: Bool
    let response: HotDebateSuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct HotDebateSuccessResponse : Codable {
    let debateId: Int
    let title: String
    let optionA: String
    let optionACount: Int
    let optionB: String
    let optionBCount: Int
    let join: Bool
    let joinOption: String?
    let deadline: String
}
