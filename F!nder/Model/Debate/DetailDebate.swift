//
//  DetailDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

struct DetailDebateResponse : Codable {
    let success: Bool
    let response: DetailDebateSuccessResponse?
    let errorResponse: DetailDebateErrorResponse?
}

struct DetailDebateSuccessResponse : Codable {
    let debateId: Int
    let debateTitle: String
    let optionA: String
    let optionACount: Int
    let optionB: String
    let optionBCount: Int
    let answerCount: Int
    let writerId: Int
    let writerNickname: String
    let writerMBTI: String
    let join: Bool
    let joinOption: String?
    let deadline: String
}

struct DetailDebateErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
