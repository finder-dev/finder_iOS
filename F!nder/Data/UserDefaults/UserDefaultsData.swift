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
    @UserDefaultsWrapper(key: "isFirstTime", defaultValue: true)
    static var isFirstTime
    
    @UserDefaultsWrapper(key: "userId", defaultValue: 0)
    static var userId
    @UserDefaultsWrapper(key: "userEmail", defaultValue: "userEmail")
    static var userEmail
    @UserDefaultsWrapper(key: "userMBTI", defaultValue: "userMBTI")
    static var userMBTI
    @UserDefaultsWrapper(key: "userNickName", defaultValue: "userNickName")
    static var userNickName
    
}
