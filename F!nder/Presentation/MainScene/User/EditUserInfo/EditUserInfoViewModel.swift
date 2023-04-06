//
//  EditUserInfoViewModel.swift
//  F!nder
//
//  Created by 장선영 on 2023/04/06.
//

import Foundation
import RxSwift

final class EditUserInfoViewModel {
    struct Input {
        let mbti = PublishSubject<String>()
        let nickNameConfirm = PublishSubject<String>()
        let password = PublishSubject<String>()
        let passwordCheck = PublishSubject<String>()
        let changeButtonTrigger = PublishSubject<Void>()
    }
    
    struct Output {
        let passwordValidation = PublishSubject<Bool>()
        let passwordIsChecked = PublishSubject<Bool>()
        let changeButtonEnabled = BehaviorSubject<Bool>(value: false)
    }
    
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    var password = ""
    
    init() {
        self.bind()
    }
    
    func bind() {
        
        self.input.nickNameConfirm
            .subscribe(onNext: { [weak self] nickname in
                self?.confirmNickName(nickName: nickname)
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
        
        self.input.changeButtonTrigger
            .subscribe(onNext: { [weak self] _ in
                self?.changeButton()
            })
            .disposed(by: disposeBag)
    }
}

private extension EditUserInfoViewModel {
    func confirmNickName(nickName: String) {
        print("nickName: \(nickName)")
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
    
    func changeButton() {
        print("change!")
    }
}
