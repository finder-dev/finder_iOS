//
//  EditUserInfoViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import UIKit
import RxSwift
import SnapKit
import Then

final class EditUserInfoViewController: BaseViewController {
    
    private let headerView = HeaderView(title: "개인 정보 수정")
    private let nicknameInsertView = InsertDataView(dataType: .nickname)
    private let mbtiInsertView = InsertDataView(dataType: .mbti)
    private let passwordInsertView = InsertDataView(dataType: .password)
    private let passwordCheckInsertView = InsertDataView(dataType: .passwordCheck)
    
    let nextButton = UIButton()
    let userAPI = UserInfoAPI()
    
    var passwordIsSame = false {
        didSet {
            checkEnableNextButtonOrNot()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        super.addView()
        
        [headerView].forEach {
            self.view.addSubview($0)
        }
        
        [nicknameInsertView, mbtiInsertView, passwordInsertView, passwordCheckInsertView].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        
        stackView.spacing = 16.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 64.0, left: 24.0,
                                               bottom: 26.0, right: 24.0)
        
        nextButton.setTitle("변경", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        nextButton.setTitleColor(.grey8, for: .normal)
        nextButton.backgroundColor = .grey7
        //TODO: for test
        nextButton.isEnabled = true
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    override func bindViewModel() {
        
        headerView.closeButton.rx.tap
            .subscribe(onNext:  { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        mbtiInsertView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let nextVC = SelectMBTIElementViewController()
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.delegate = self
                self?.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension EditUserInfoViewController: MBTIElementViewControllerDelegate {
    
    func selectMBTI(mbti: String) {
        mbtiInsertView.textField.text = mbti
        checkEnableNextButtonOrNot()
    }
}

extension EditUserInfoViewController: UITextFieldDelegate {
    
    func checkEnableNextButtonOrNot() {
        print(" checkEnableNextButtonOrNo")
        guard let mbti = mbtiInsertView.textField.text else {
            return
        }
        
        guard let password = passwordInsertView.textField.text else {
            return
        }
        
        
        if password.isEmpty {
            if nicknameInsertView.requestButton.isEnabled == false && !mbti.isEmpty {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .primary
                nextButton.setTitleColor(.white, for: .normal)
            } else {
                nextButton.isEnabled = false
                nextButton.setTitleColor(.grey8, for: .normal)
                nextButton.backgroundColor = .grey7
            }
        } else {
            if nicknameInsertView.requestButton.isEnabled == false && !mbti.isEmpty && passwordIsSame {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .primary
                nextButton.setTitleColor(.white, for: .normal)
            } else {
                nextButton.isEnabled = false
                nextButton.setTitleColor(.grey8, for: .normal)
                nextButton.backgroundColor = .grey7
            }
        }
    }

    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let password = passwordCheckInsertView.textField.text else {
            return
        }
        
        if password == textField.text {
            passwordCheckInsertView.subTitleLabel.text = "비밀번호가 일치합니다"
            passwordCheckInsertView.subTitleLabel.textColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
            passwordIsSame = true
            print("일치")
        } else {
            print("불일치")
            passwordCheckInsertView.subTitleLabel.text = "동일하지 않은 비밀번호입니다"
            passwordCheckInsertView.subTitleLabel.textColor = .primary
            passwordIsSame = false
        }
    }
    
    @objc func textFieldDidChange2(_ textField: UITextField) {
        checkEnableNextButtonOrNot()
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


private extension EditUserInfoViewController {
    
    @objc func didTapNickNameCheckButton() {
        print("didTapNickNameCheckButton")
        guard let nickName = nicknameInsertView.textField.text else {
            return
        }
        
        nicknameInsertView.requestButton.isEnabled = false
        
        userAPI.requestCheckNickname(nickname: nickName) { [self] result in
            switch result {
            case let .success(response) :
                
                if response.success {
                    guard let response = response.response else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        showPopUp1(title: response.message, message: "", buttonText: "확인", buttonAction: { })
                        checkEnableNextButtonOrNot()
                    }
                } else {
                    guard let error = response.errorResponse else {
                        return
                    }
                    
//                    print(error.errorMessages)
                    DispatchQueue.main.async {
                        showPopUp1(title: "닉네임 사용 불가", message: error.errorMessages[0], buttonText: "확인", buttonAction: { })
                    }
                }
                
            case .failure(_):
                print("오류")
            }
        }
    }
    
    @objc func didTapIdCheckButton() {
        print("didTapIdCheckButton")
    }
    @objc func didTapNextButton() {
        print("didTapNextButton")
        guard let nickName = nicknameInsertView.textField.text,
              let mbti = mbtiInsertView.textField.text else {
            return
        }
        
        var password :String?
        
        if !passwordIsSame {
            password = nil
        } else {
            password = passwordInsertView.textField.text!
        }
        
        userAPI.requestChangeUserInfo(nickName: nickName,
                                      mbti: mbti,
                                      password: password) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    DispatchQueue.main.async {
                        showPopUp1(title: "개인정보 수정 완료", message: "수정되었습니다.", buttonText: "확인", buttonAction: { })
                       
                        let userMBTI = response.response?.mbti ?? "nil"
                        let userNickName = response.response?.nickname ?? "nil"
                        
                        UserDefaultsData.userMBTI = userMBTI
                        UserDefaultsData.userNickName = userNickName
                    }
                }
                print(response.response)
                print(response.errorResponse)
                
            case .failure(_):
                print("오류")
            }
        }
    }
}
