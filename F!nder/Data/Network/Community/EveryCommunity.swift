//
//  EveryCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct EveryCommunity {
    let mbti: String?
    let orderBy: String?
    let page: Int
    
    var parameters : [String: Any] { [
        "mbti": mbti,
        "orderBy": orderBy,
        "page": page
    ]}
}

struct EveryCommunityResponse : Codable {
    let success: Bool
    let response: EveryCommunitySuccessResponse?
    let errorResponse: ErrorReponseDTO?

struct EveryCommunitySuccessResponse : Codable {
    let content: [content]
    let last: Bool
}

struct content : Codable {
    let communityId: Int
    let communityTitle: String
    let communityContent: String
    let communityMBTI: String
    let imageUrl: String?
    let userNickname: String
    let userMBTI: String
    let likeUser: Bool
    let likeCount: Int
    let answerCount: Int
    let isQuestion: Bool
    let createTime: String
}
