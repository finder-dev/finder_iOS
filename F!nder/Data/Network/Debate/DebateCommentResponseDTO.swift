//
//  DebateComment.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/20.
//

import Foundation

// MARK: - Data Transfer Object

struct DebateCommentResponseDTO: Codable {
    let success: Bool
    let response: DebateCommentSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

extension DebateCommentResponseDTO {
    struct DebateCommentSuccessDTO: Codable {
        let debateAnswerId: Int
    }
}
