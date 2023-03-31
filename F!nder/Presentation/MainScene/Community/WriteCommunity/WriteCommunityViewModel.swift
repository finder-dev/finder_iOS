//
//  WriteCommunityViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import Foundation
import RxSwift
import UIKit

final class WriteCommunityViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        var imageCollectionViewDataSource = BehaviorSubject<[UIImage]>(value: [UIImage(named: "Group 986367") ?? UIImage()])
    }
    
    let input = Input()
    let output = Output()
    
    init() {
        self.bind()
    }
    
    func bind() {
       
    }
}
