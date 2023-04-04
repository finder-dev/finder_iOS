//
//  SettingViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/04/04.
//

import Foundation
import RxSwift

final class SettingViewModel {
    
    struct Input {
        let deleteAccountTrigger = PublishSubject<Void>()
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
        self.input.deleteAccountTrigger
            .subscribe(onNext: {
                print("Lets deleteAccount!")
            })
            .disposed(by: disposeBag)
    }
}
