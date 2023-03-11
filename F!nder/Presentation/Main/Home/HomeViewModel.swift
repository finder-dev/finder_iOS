//
//  HomeViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        var hotCommunityTableViewDataSource = BehaviorSubject<[HotCommunitySuccessResponse]>(value: [])
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.output.hotCommunityTableViewDataSource.onNext(returnCommunityTableViewData())
    }
}

// TestData
extension HomeViewModel {
    func returnCommunityTableViewData() -> [HotCommunitySuccessResponse] {
        let array = [HotCommunitySuccessResponse(communityId: 0, title: "testest"),
                     HotCommunitySuccessResponse(communityId: 0, title: "testest"),
                     HotCommunitySuccessResponse(communityId: 0, title: "testest"),
                     HotCommunitySuccessResponse(communityId: 0, title: "testest"),
                     HotCommunitySuccessResponse(communityId: 0, title: "testest")]
        return array
    }
}
