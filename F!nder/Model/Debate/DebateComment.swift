//
//  DebateComment.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/20.
//

import Foundation

struct DebateCommentResponse : Codable {
    let success: Bool
    let response: DebateCommentSuccessResponse?
    let errorResponse: DebateCommentErrorResponse?
}

struct DebateCommentSuccessResponse : Codable {
    let debateAnswerId: Int
}

struct DebateCommentErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
