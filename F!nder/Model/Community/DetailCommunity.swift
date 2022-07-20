//
//  DetailCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

struct DetailCommunityResponse : Codable {
    let success: Bool
    let response: DetailCommunitySuccessResponse?
    let errorResponse: DetailCommunityErrorResponse?
}

struct DetailCommunitySuccessResponse : Codable {
    let communityId: Int
    let communityTitle: String
    let communityContent: String
    let communityMBTI: String
    let imageUrl: String?
    let likeCount: Int
    let likeUser: Bool
    let saveUser: Bool
    let userId: Int
    let userMBTI: String
    let userNickname: String
    let answerCount: Int
    let isQuestion: Bool
    let createTime: String
    let answerHistDtos : [answerHistDtos]?
}

struct DetailContent : Codable {
    let communityId: Int
    let communityTitle: String
    let communityContent: String
    let communityMBTI: String
    let imageUrl: String?
    let likeCount: Int
    let likeUser: Bool
    let saveUser: Bool
    let userId: Int
    let userMBTI: String
    let userNickname: String
    let answerCount: Int
    let isQuestion: Bool
    let createTime: String
}

struct DetailCommunityErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
