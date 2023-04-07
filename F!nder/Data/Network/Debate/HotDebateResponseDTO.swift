//
//  HotDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

// MARK: - Data Transfer Object

struct HotDebateResponseDTO: Codable {
    let success: Bool
    let response: HotDebateSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

extension HotDebateResponseDTO {
    struct HotDebateSuccessDTO: Codable {
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
}
