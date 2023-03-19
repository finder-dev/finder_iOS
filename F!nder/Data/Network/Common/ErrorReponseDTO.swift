//
//  ErrorReponseDTO.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/19.
//

import Foundation

struct ErrorReponseDTO: Codable {
    let status: Int
    let errorMessages: [String]
}
