//
//  CommunityComment.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/21.
//

import Foundation

struct CommunityComment {
    let content: String
    
    var parameters : [String: String] { [
        "content": content
    ]}
}

struct CommunityCommentResponse : Codable {
    let success: Bool
    let response: CommunityCommentSuccessResponse?
    let errorResponse: ErrorReponseDTO?
}

struct CommunityCommentSuccessResponse : Codable {
    let communityAnswerId: Int
}
