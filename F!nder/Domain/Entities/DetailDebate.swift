//
//  DetailDebate.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/19.
//

import Foundation

struct DetailDebate {
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
    let answerHistDtos: [Answer]?
}
