//
//  File.swift
//  
//
//  Created by 장선영 on 2023/04/19.
//

import Foundation

protocol Request {
    var baseURL: URL { get }
    var path: String { get }
    var method: HttpMethod { get }
    var task: Any { get }
    var headers: [String: String]? { get }
}
