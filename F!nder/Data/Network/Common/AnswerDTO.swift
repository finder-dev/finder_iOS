//
//  AnswerDTO.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/19.
//

import Foundation

struct AnswerDTO: Codable {
    let answerId: Int
    let answerContent :String
    let userId: Int
    let userMBTI:String
    let userNickname:String
    let createTime:String
    let replyHistDtos: [ReplyDTO]?
}

extension AnswerDTO {
    func toDomain() -> Answer {
        
        return .init(answerId: answerId,
                     answerContent: answerContent,
                     userId: userId,
                     userMBTI: userMBTI,
                     userNickname: userNickname,
                     createTime: createTime,
                     replyHistDtos: replyHistDtos?.map { $0.toDomain() })
    }
}
