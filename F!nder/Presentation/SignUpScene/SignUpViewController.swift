//
//  SignUpViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/25.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpViewController: BaseViewController {
    
    let signUpProcessView = SignUpProcessView()
    let idInsertView = InsertDataView(dataType: .id)
    let codeInsertView = InsertDataView(dataType: .code)
    let passwordInsertView = InsertDataView(dataType: .password)
    let passwordCheckInsertView = InsertDataView(dataType: .passwordCheck)
    let mbtiInsertView = InsertDataView(dataType: .mbti)
    let nicknameInsertView = InsertDataView(dataType: .nickname)
    let spaceView = UIView()
    let nextButton = FinderButton(buttonText: "다음")
    
    var signUpProcess: SignUpProcess = .insertData {
        didSet {
            changeView(as: signUpProcess)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addView() {
        super.addView()
        
        [signUpProcessView, idInsertView, codeInsertView, passwordInsertView,
         passwordCheckInsertView, mbtiInsertView, nicknameInsertView, spaceView].forEach {
            self.stackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(nextButton)
    }
    
    override func setLayout() {
        super.setLayout()
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(26.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
        }
        
        spaceView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(100.0)
        }
    }
    
    override func setupView() {
        self.title = "회원가입"
        self.view.backgroundColor = .white
        self.signUpProcess = .insertData
        self.nextButton.isEnabled = false
        
        stackView.spacing = 16.0
        stackView.setCustomSpacing(36.0, after: signUpProcessView)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0.0, left: 24.0,
                                               bottom: 26.0, right: 24.0)
        
    }
    
    override func bindViewModel() {
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.signUpProcess = self?.signUpProcess == .insertData ? .settingProfile : .completeSignUp
            })
            .disposed(by: disposeBag)
        
        idInsertView.requestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextButton.isEnabled = true
                
            })
            .disposed(by: disposeBag)
    }

}

private extension SignUpViewController {
    func changeView(as process: SignUpProcess) {
        signUpProcessView.process = process
        
        switch process {
        case .insertData:
            mbtiInsertView.isHidden = true
            nicknameInsertView.isHidden = true
            
        case .settingProfile:
            mbtiInsertView.isHidden = false
            nicknameInsertView.isHidden = false
            [idInsertView, codeInsertView, passwordInsertView,
             passwordCheckInsertView].forEach {
                $0.isHidden = true
            }
            nextButton.isEnabled = false
        case .completeSignUp:
            let nextVC = CompleteSignUpViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
