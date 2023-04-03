//
//  UserViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/04/03.
//

import Foundation
import RxSwift
import RxRelay

final class UserViewModel {
    
    struct Input {
        let logoutTrigger = PublishSubject<Void>()
    }
    
    struct Output {
      
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.input.logoutTrigger
            .subscribe(onNext: { 
                print("Lets logout!")
            })
            .disposed(by: disposeBag)
    }
}
