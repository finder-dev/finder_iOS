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
    let errorResponse: ErrorReponseDTO?

struct HotCommunitySuccessResponse : Codable {
    let communityId: Int
    let title: String
}
