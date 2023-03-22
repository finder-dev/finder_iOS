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
        var hotCommunityTableViewDataSource = BehaviorSubject<[HotCommunitySuccessDTO]>(value: [])
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
    func returnCommunityTableViewData() -> [HotCommunitySuccessDTO] {
        let array = [HotCommunitySuccessDTO(communityId: 0, title: "testest"),
                     HotCommunitySuccessDTO(communityId: 0, title: "testest"),
                     HotCommunitySuccessDTO(communityId: 0, title: "testest"),
                     HotCommunitySuccessDTO(communityId: 0, title: "testest"),
                     HotCommunitySuccessDTO(communityId: 0, title: "testest")]
        return array
    }
}
