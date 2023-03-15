//
//  MakeDebateViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/15.
//

import Foundation
import RxSwift

final class MakeDebateViewModel {
    
    struct Input {
        let completeButtonTrigger = PublishSubject<Void>()
        let debateTitle = PublishSubject<String?>()
        let optionA = PublishSubject<String?>()
        let optionB = PublishSubject<String?>()
    }
    
    struct Output {
       var isFilled = BehaviorSubject<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    var debate = DebateModel()
    let disposeBag = DisposeBag()
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.input.debateTitle
            .subscribe(onNext: { [weak self] title in
                self?.debate.debateTitle = title ?? ""
                self?.isDebateModelFilled()
            })
            .disposed(by: disposeBag)
        
        self.input.optionA
            .subscribe(onNext: { [weak self] optionA in
                self?.debate.optionA = optionA ?? ""
                self?.isDebateModelFilled()
            })
            .disposed(by: disposeBag)
        
        self.input.optionB
            .subscribe(onNext: { [weak self] optionB in
                self?.debate.optionB = optionB ?? ""
                self?.isDebateModelFilled()
            })
            .disposed(by: disposeBag)
    }
}

private extension MakeDebateViewModel {
    func isDebateModelFilled() {
        if debate.debateTitle != "" && debate.optionA != "" && debate.optionB != "" {
            self.output.isFilled.onNext(true)
        } else {
            self.output.isFilled.onNext(false)
        }
    }
}
