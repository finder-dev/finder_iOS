//
//  HotCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import Foundation

struct HotCommunityResponseDTO: Codable {
    let success: Bool
    let response: [HotCommunitySuccessDTO]
    let errorResponse: ErrorReponseDTO?
}

struct HotCommunitySuccessDTO: Codable {
    let communityId: Int
    let title: String
}
