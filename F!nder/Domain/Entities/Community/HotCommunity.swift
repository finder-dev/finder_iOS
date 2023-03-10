//
//  HotCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct HotCommunityResponse : Codable {
    let success: Bool
    let response: [HotCommunitySuccessResponse]
    let errorResponse: HotCommunityErrorResponse?
}

struct HotCommunitySuccessResponse : Codable {
    let communityId: Int
    let title: String
}

struct HotCommunityErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
