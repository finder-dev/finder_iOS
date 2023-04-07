//
//  SavedViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/31.
//

import Foundation
import RxSwift
import RxRelay

final class SavedViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let communityTableViewDataSource = BehaviorRelay<[CommunityTable]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.output.communityTableViewDataSource.accept(returnTempData())
    }
}

private extension SavedViewModel {
    func returnTempData() -> [CommunityTable] {
        let array = [CommunityTable(communityId: 1,
                             communityTitle: "잇티제들은 표현해주는 거 좋아함? 언제는 부담스럽다더니 이제는 왜 안 하냐는데",
                             communityContent: "test testest",
                             communityMBTI: "INFJ",
                             imageUrl: nil,
                             userNickname: "포포",
                             userMBTI: "infj",
                             likeUser: true,
                             likeCount: "9",
                             answerCount: "4",
                             isQuestion: true,
                             createTime: "1분전"),
                     CommunityTable(communityId: 1,
                                          communityTitle: "test",
                                          communityContent: "test testest test testest test testest test testest test testest test testest test testest test testest test testest test testest test testest",
                                          communityMBTI: "infj",
                                          imageUrl: nil,
                                          userNickname: "포포",
                                          userMBTI: "infj",
                                          likeUser: false,
                                          likeCount: "9",
                                          answerCount: "4",
                                          isQuestion: true,
                             createTime: "1분전"),
                     CommunityTable(communityId: 1,
                                          communityTitle: "test",
                                          communityContent: "test testest",
                                          communityMBTI: "infj",
                                          imageUrl: nil,
                                          userNickname: "포포",
                                          userMBTI: "infj",
                                          likeUser: true,
                                          likeCount: "9",
                                          answerCount: "4",
                                          isQuestion: false,
                                          createTime: "1분전"),
                     CommunityTable(communityId: 1,
                                          communityTitle: "test",
                                          communityContent: "test testest",
                                          communityMBTI: "infj",
                                          imageUrl: nil,
                                          userNickname: "포포",
                                          userMBTI: "infj",
                                          likeUser: false,
                                          likeCount: "9",
                                          answerCount: "4",
                                          isQuestion: true,
                                          createTime: "1분전"),
                     CommunityTable(communityId: 1,
                                          communityTitle: "test",
                                          communityContent: "test testest",
                                          communityMBTI: "infj",
                                          imageUrl: nil,
                                          userNickname: "포포",
                                          userMBTI: "infj",
                                          likeUser: true,
                                          likeCount: "9",
                                          answerCount: "4",
                                          isQuestion: false,
                                          createTime: "1분전")]
        
        return array
    }
}
