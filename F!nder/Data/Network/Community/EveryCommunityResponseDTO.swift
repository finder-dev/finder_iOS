//
//  EveryCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct EveryCommunityResponseDTO: Codable {
    let success: Bool
    let response: EveryCommunitySuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct EveryCommunitySuccessDTO: Codable {
    let content: [CommunityTableDTO]
    let last: Bool
}

struct CommunityTableDTO: Codable, Equatable {
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

extension CommunityTableDTO {
    func toDomain() -> CommunityTable {
        
        return .init(communityId: communityId,
                     communityTitle: communityTitle,
                     communityContent: communityContent,
                     communityMBTI: communityMBTI,
                     imageUrl: imageUrl,
                     userNickname: userNickname,
                     userMBTI: userMBTI,
                     likeUser: likeUser,
                     likeCount: "\(likeCount)",
                     answerCount: "\(answerCount)",
                     isQuestion: isQuestion,
                     createTime: createTime)
    }
}

//struct EveryCommunity {
//    let mbti: String?
//    let orderBy: String?
//    let page: Int
//
//    var parameters : [String: Any] { [
//        "mbti": mbti,
//        "orderBy": orderBy,
//        "page": page
//    ]}
//}

