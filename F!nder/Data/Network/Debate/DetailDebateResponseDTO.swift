//
//  DetailDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

// MARK: - Data Transfer Object

struct DetailDebateResponseDTO: Codable {
    let success: Bool
    let response: DetailDebateSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

extension DetailDebateResponseDTO {
    struct DetailDebateSuccessDTO: Codable {
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
        let answerHistDtos: [AnswerDTO]?
    }
}

// MARK: - Mappings to Domain

extension DetailDebateResponseDTO.DetailDebateSuccessDTO {
    func toDomain() -> DetailDebate {
        
        return .init(debateId: debateId,
                     debateTitle: debateTitle,
                     optionA: optionA,
                     optionACount: optionACount,
                     optionB: optionB,
                     optionBCount: optionBCount,
                     answerCount: answerCount,
                     writerId: writerId,
                     writerNickname: writerNickname,
                     writerMBTI: writerMBTI,
                     join: join,
                     joinOption: joinOption,
                     deadline: deadline,
                     answerHistDtos: answerHistDtos?.map { $0.toDomain() })
    }
}
