//
//  SignupInsertDataType.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/12.
//

import Foundation

enum SignupInsertDataType: String {
    case id = "아이디(이메일)"
    case code = "코드번호"
    case password = "비밀번호"
    case passwordCheck = ""
    case mbti = "MBTI"
    case nickname = "닉네임"
        
    var placeHolder: String {
        switch self {
        case .id:
            return "이메일을 인증해주세요"
        case .code:
            return "코드번호를 입력해주세요"
        case .password:
            return "비밀번호를 입력해주세요"
        case .passwordCheck:
            return "비밀번호를 다시 입력해주세요"
        case .mbti:
            return "MBTI를 선택해주세요"
        case .nickname:
            return "6자 이내로 적어주세요"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .id:
            return "인증요청"
        case .code:
            return "인증확인"
        case .nickname:
            return "중복확인"
        case .password, .passwordCheck,.mbti:
            return ""
        }
    }
}
