//
//  SaveCommunity.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/20.
//

import Foundation

struct SaveCommunityResponseDTO: Codable {
    let success: Bool
    let response: SaveCommunitySuccessDTO?
    let errorResponse: ErrorReponseDTO?
}

struct SaveCommunitySuccessDTO: Codable {
    let message: String
}
