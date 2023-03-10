//
//  UserDefaultsData.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import Foundation

enum UserDefaultsData {
    
    @UserDefaultsWrapper(key: "accessToken", defaultValue: "")
    static var accessToken
    
    @UserDefaultsWrapper(key: "userId", defaultValue: 0)
    static var userId
    @UserDefaultsWrapper(key: "userEmail", defaultValue: "")
    static var userEmail
    @UserDefaultsWrapper(key: "userMBTI", defaultValue: "")
    static var userMBTI
    @UserDefaultsWrapper(key: "userNickName", defaultValue: "")
    static var userNickName
    
}
