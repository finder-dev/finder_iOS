//
//  SaveCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/20.
//

import Foundation

struct SaveCommunityResponse : Codable {
    let success: Bool
    let response: SaveCommunitySuccessResponse?
    let errorResponse: SaveCommunityErrorResponse?
}

struct SaveCommunitySuccessResponse : Codable {
    let message: String
}

struct SaveCommunityErrorResponse: Codable {
    let status: Int
    let errorMessages: [String]
}
