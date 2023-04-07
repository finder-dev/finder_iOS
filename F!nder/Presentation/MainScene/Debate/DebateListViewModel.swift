//
//  DebateListViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/14.
//

import Foundation
import RxSwift
import RxRelay

final class DebateListViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        var debateTableViewDataSource = BehaviorSubject<[DebateContent]>(value: [])
        var debateViewStatus = BehaviorSubject<DebateListViewStatus>(value: .hasData)
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.output.debateTableViewDataSource.onNext(returnCommunityTableViewData())
    }
}

// TestData
extension DebateListViewModel {
    func returnCommunityTableViewData() -> [DebateContent] {
        let array = [DebateContent(debateId: 0,
                                      debateTitle: "친구의 깻잎, 19장이 엉겨붙었는데 애인이 떼줘도 된다?",
                                      joinState: "42명 참여",
                                      debateState: "", deadLine: "D-6"),
                     DebateContent(debateId: 0,
                                                   debateTitle: "여사친 롱패딩 지퍼 올려준다 만다",
                                                   joinState: "42명 참여",
                                                   debateState: "", deadLine: "D-6"),
                     DebateContent(debateId: 0,
                                                   debateTitle: "친구의 깻잎, 19장이 엉겨붙었는데 애인이 떼줘도 된다?",
                                                   joinState: "42명 참여",
                                                   debateState: "", deadLine: "D-6"),
                     DebateContent(debateId: 0,
                                                   debateTitle: "친구의 깻잎, 19장이 엉겨붙었는데 애인이 떼줘도 된다?",
                                                   joinState: "42명 참여",
                                                   debateState: "", deadLine: "D-6")]
        return array
    }
}
