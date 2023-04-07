//
//  MakeDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

// MARK: - Data Transfer Object

struct MakeDebateResponseDTO: Codable {
    let success: Bool
    let response: MakeDebateSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

extension MakeDebateResponseDTO {
    struct MakeDebateSuccessDTO: Codable {
        let debateId: Int
    }
}
