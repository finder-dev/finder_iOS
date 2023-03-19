//
//  ReplyDTO.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/19.
//

import Foundation

struct ReplyDTO: Codable {
    let replyId: Int
    let replyContent: String
    let userId: Int
    let userMBTI: String
    let createTime: String
}

extension ReplyDTO {
    func toDomain() -> Reply {
        
        return .init(replyId: replyId,
                     replyContent: replyContent,
                     userId: userId,
                     userMBTI: userMBTI,
                     createTime: createTime)
    }
}
