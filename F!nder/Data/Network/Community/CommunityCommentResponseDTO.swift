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

struct CommunityCommentResponseDTO: Codable {
    let success: Bool
    let response: CommunityCommentSuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct CommunityCommentSuccessDTO: Codable {
    let communityAnswerId: Int
}
