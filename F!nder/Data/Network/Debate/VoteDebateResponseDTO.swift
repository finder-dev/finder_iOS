//
//  VoteDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

// MARK: - Data Transfer Object

struct VoteDebateResponseDTO: Codable {
    let success: Bool
    let response: VoteDebateSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

extension VoteDebateResponseDTO {
    struct VoteDebateSuccessDTO: Codable {
        let message: String
        let option:String
    }
}
