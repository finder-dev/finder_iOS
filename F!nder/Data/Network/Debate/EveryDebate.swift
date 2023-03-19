//
//  EveryDebate.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

struct EveryDebateResponse : Codable {
    let success: Bool
    let response: EveryDebateSuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct EveryDebateSuccessResponse : Codable {
    let content: [debateContent]
    let last:Bool
}

struct debateContent : Codable {
    let debateId: Int
    let title: String
    let joinCount: Int
    let debateState: String
    let deadline: String

    
    var toEntity: DebateTableModel {
        
       return DebateTableModel(debateId: debateId,
                               debateTitle: title,
                               joinState: "\(joinCount)명 참여",
                               debateState: debateState,
                               deadLine: deadline)
    }
}
