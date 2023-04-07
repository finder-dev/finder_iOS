//
//  EveryDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

// MARK: - Data Transfer Object

struct EveryDebateResponseDTO: Codable {
    let success: Bool
    let response: EveryDebateSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

extension EveryDebateResponseDTO {
    struct EveryDebateSuccessDTO: Codable {
        let content: [DebateContentDTO]
        let last:Bool
    }
}

extension EveryDebateResponseDTO.EveryDebateSuccessDTO {
    struct DebateContentDTO: Codable {
        let debateId: Int
        let title: String
        let joinCount: Int
        let debateState: String
        let deadline: String
    }
}

// MARK: - Mappings to Domain

extension EveryDebateResponseDTO.EveryDebateSuccessDTO.DebateContentDTO {
    func toDomain() -> DebateContent {
        return .init(debateId: debateId,
                     debateTitle: title,
                     joinState: "\(joinCount)명 참여",
                     debateState: debateState,
                     deadLine: deadline)
    }
}
