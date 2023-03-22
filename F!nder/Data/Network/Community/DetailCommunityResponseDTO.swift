//
//  DetailCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import Foundation

struct DetailCommunityResponseDTO: Codable {
    let success: Bool
    let response: DetailCommunitySuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct DetailCommunitySuccessDTO: Codable {
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
    let answerHistDtos : [AnswerDTO]?
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
