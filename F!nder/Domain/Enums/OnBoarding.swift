//
//  OnBoard.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import Foundation

enum OnBoarding: Int, CaseIterable {
    case page1 = 0
    case page2 = 1
    case page3 = 2
    
    var title: String {
        switch self {
        case .page1:
            return "궁금한 MBTI한테\n바로 물어보세요"
        case .page2:
            return "마음 놓고\n토론하세요"
        case .page3:
            return "세상에 나쁜\nMBTI는 없다"
        }
    }
    
    var subTitle: String {
        switch self {
        case .page1:
            return "오해와 진실! 여기서 다 풀어요"
        case .page2:
            return "각종 논쟁들 끝내러 오셨군요!"
        case .page3:
            return "과몰입러들끼리 솔직담백한 \n얘기들을 나눠보세요"
        }
    }
    
    static func getOnBoardingPage(_ page: Int) -> OnBoarding {
        return self.allCases.first { $0.rawValue == page } ?? page1
    }
}
