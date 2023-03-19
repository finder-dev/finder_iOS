//
//  AnswerModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/19.
//

import Foundation

struct Answer {
    let answerId: Int
    let answerContent: String
    let userId: Int
    let userMBTI: String
    let userNickname: String
    let createTime: String
    let replyHistDtos: [Reply]?
}
