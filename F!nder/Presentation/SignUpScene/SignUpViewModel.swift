//
//  SignUpViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/12.
//

import Foundation
import RxSwift


final class SignUpViewModel {
    
    struct Input {
        let idConfirmTrigger = PublishSubject<String>()
        let codeConfirmTrigger = PublishSubject<String>()
        let password = PublishSubject<String>()
        let passwordCheck = PublishSubject<String>()
        let mbti = PublishSubject<String>()
        let nickNameConfirmTrigger = PublishSubject<String>()
    }
    
    struct Output {
        let passwordValidation = PublishSubject<Bool>()
        let passwordIsChecked = PublishSubject<Bool>()
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    var password = ""
    
    init() {
        self.bind()
    }
    
    func bind() {
        self.input.idConfirmTrigger
            .subscribe(onNext: { [weak self] id in
                self?.confirmId(id: id)
            })
            .disposed(by: disposeBag)
        
        self.input.codeConfirmTrigger
            .subscribe(onNext: { [weak self] code in
                self?.confirmCode(code: code)
            })
            .disposed(by: disposeBag)
        
        self.input.password
            .subscribe(onNext: { [weak self] password in
                self?.password = password
                self?.checkPasswordValidation(password: password)
            })
            .disposed(by: disposeBag)
        
        self.input.passwordCheck
            .subscribe(onNext: { [weak self] password in
                self?.checkPassword(checkPassword: password)
            })
            .disposed(by: disposeBag)
    }
}

private extension SignUpViewModel {
    
    func confirmId(id: String) {
        
    }
    
    func confirmCode(code: String) {
        
    }
    
    func checkPasswordValidation(password: String) {
        // TODO : 추후 수정
        self.password = password
        // 8~16 자리
        let lengthreg = ".{8,16}"
        let lengthtesting = NSPredicate(format: "SELF MATCHES %@", lengthreg)
        if lengthtesting.evaluate(with: password) == false {
            self.output.passwordValidation.onNext(false)
            return
        }
        // 문자와 숫자를 포함 여부
        let combinationreg = "^(?=.*[A-Za-z])(?=.*[0-9]).{8,16}"
        let combinationtesting = NSPredicate(format: "SELF MATCHES %@", combinationreg)
        if combinationtesting.evaluate(with: password) == false {
            self.output.passwordValidation.onNext(false)
            return
        }
        // 특수문자 포함 여부
        let specialreg = "^(?=.*[!@#$%^&*()_+=-]).{8,16}"
        let specialtesting = NSPredicate(format: "SELF MATCHES %@", specialreg)
        if specialtesting.evaluate(with: password) == true {
            self.output.passwordValidation.onNext(false)
            return
        }
        
        self.output.passwordValidation.onNext(true)
    }
    
    func checkPassword(checkPassword: String) {
        self.output.passwordIsChecked.onNext(self.password == checkPassword)
    }
}
