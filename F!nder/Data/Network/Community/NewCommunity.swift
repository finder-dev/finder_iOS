//
//  NewCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/21.
//

import Foundation

struct NewCommunity {
    let title: String
    let content: String
    let mbti: String
    let isQuestion: Bool
    
    var parameters : [String: Any] { [
        "title": title,
        "content": content,
        "mbti": mbti,
        "isQuestion": isQuestion
    ]}
}

struct NewCommunityResponse : Codable {
    let success: Bool
    let response: NewCommunitySuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct NewCommunitySuccessResponse : Codable {
    let communityId: Int
}

