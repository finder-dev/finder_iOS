//
//  File.swift
//  
//
//  Created by 장선영 on 2023/04/21.
//

import Foundation

public enum HttpMethod {
    case get
    case post
    case put
    case patch
    case delete
    
    var value: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}
