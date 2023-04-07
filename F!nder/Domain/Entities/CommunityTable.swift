//
//  CommunityTable.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import Foundation

struct CommunityTable: Equatable {
    let communityId: Int
    let communityTitle: String
    let communityContent: String
    let communityMBTI: String
    let imageUrl: String?
    let userNickname: String
    let userMBTI: String
    let likeUser: Bool
    let likeCount: String
    let answerCount: String
    let isQuestion: Bool
    let createTime: String
}
