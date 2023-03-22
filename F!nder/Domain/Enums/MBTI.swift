//
//  MBTI.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import Foundation
import UIKit

enum MBTI: String, CaseIterable {
    case every = "전체"
    case infj = "INFJ"
    case infp = "INFP"
    case isfj = "ISFJ"
    case isfp = "ISFP"
    case intj = "INTJ"
    case intp = "INTP"
    case istj = "ISTJ"
    case istp = "ISTP"
    case enfj = "ENFJ"
    case enfp = "ENFP"
    case esfj = "ESFJ"
    case esfp = "ESFP"
    case entj = "ENTJ"
    case entp = "ENTP"
    case estj = "ESTJ"
    case estp = "ESTP"
    
    var mbtiMessage: String {
        switch self {
        case .every:
            return ""
        case .infj:
            return "오늘은 하고 싶은 말 \n다 하고 오셨나요?"
        case .infp:
            return "오늘은 집 밖으로 \n나가볼까요?"
        case .isfj:
            return "어떤 독특한 일이 \n일어날까요?"
        case .isfp:
            return "오늘은 어떤 것에 \n꽂혀볼까요?"
        case .intj:
            return "어떤 호기심으로 \n가득차셨나요?"
        case .intp:
            return "어떤 곳에 열정을 \n불태워볼까요?"
        case .istj:
            return "민첩한 하루 되세요!"
        case .istp:
            return "만능 재주꾼의 시간이에요!"
        case .enfj:
            return "카리스마 넘치는 \n하루 보내세요!"
        case .enfp:
            return "오늘은 어떤 상상을 \n하셨나요?"
        case .esfj:
            return "오늘 계획도 \n완벽 수행 각!"
        case .esfp:
            return "어떤 재밌는 일이 \n기다리고 있을까요?"
        case .entj:
            return "오늘도 쿨한 하루 \n보내셨나요?"
        case .entp:
            return "자신감 충만한 \n하루 되세요!"
        case .estj:
            return "오늘도 알찬 \n하루 보내세요"
        case .estp:
            return "스릴 넘치는 \n하루 보내세요!"
        }
    }
    
    var mbtiImage: UIImage {
        switch self {
        case .every:
            return UIImage()
        case .infj:
            return UIImage(named: "Frame 7594") ?? UIImage()
        case .infp:
            return UIImage(named: "Frame 7593") ?? UIImage()
        case .isfj:
            return UIImage(named: "Frame 7595") ?? UIImage()
        case .isfp:
            return UIImage(named: "Frame 7595") ?? UIImage()
        case .intj:
            return UIImage(named: "Frame 7594") ?? UIImage()
        case .intp:
            return UIImage(named: "Frame 7592") ?? UIImage()
        case .istj:
            return UIImage(named: "Frame 7593") ?? UIImage()
        case .istp:
            return UIImage(named: "Frame 7592") ?? UIImage()
        case .enfj:
            return UIImage(named: "Frame 7595") ?? UIImage()
        case .enfp:
            return UIImage(named: "Frame 7592") ?? UIImage()
        case .esfj:
            return UIImage(named: "Frame 7594") ?? UIImage()
        case .esfp:
            return UIImage(named: "Frame 7595") ?? UIImage()
        case .entj:
            return UIImage(named: "Frame 7593") ?? UIImage()
        case .entp:
            return UIImage(named: "Frame 7593") ?? UIImage()
        case .estj:
            return UIImage(named: "Frame 7592") ?? UIImage()
        case .estp:
            return UIImage(named: "Frame 7594") ?? UIImage()
        }
    }
    
    static func getMBTI(_ mbti: String) -> MBTI {
        return self.allCases.first { $0.rawValue == mbti } ?? infj
    }
}
