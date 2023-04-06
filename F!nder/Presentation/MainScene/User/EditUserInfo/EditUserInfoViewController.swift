//
//  EditUserInfoViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class EditUserInfoViewController: BaseViewController {
    
    // MARK: - Properties
    
    let viewModel: EditUserInfoViewModel?
    let userAPI = UserInfoAPI()
    
    // MARK: - Views
    
    private let headerView = HeaderView(title: "개인 정보 수정")
    private let nicknameInsertView = InsertDataView(dataType: .nickname)
    private let mbtiInsertView = InsertDataView(dataType: .mbti)
    private let passwordInsertView = InsertDataView(dataType: .password)
    private let passwordCheckInsertView = InsertDataView(dataType: .passwordCheck)
    private let changeButton = FinderButton(buttonText: "변경")
    
    var passwordIsSame = false {
        didSet {
//            checkEnableNextButtonOrNot()
        }
    }
    
    // MARK: - Life Cycle
    
    init(viewModel: EditUserInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        super.addView()
        
        [headerView, changeButton].forEach {
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
        
        changeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).inset(26.0)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        
        stackView.spacing = 16.0
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 64.0, left: 24.0,
                                               bottom: 26.0, right: 24.0)
        passwordCheckInsertView.textField.isEnabled = false
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
        
        // MARK: Input
        
        nicknameInsertView.requestButton.rx.tap
            .bind { [weak self] _ in
                guard let nickname = self?.nicknameInsertView.textField.text else {
                    self?.showPopUp1(title: "닉네임을 작성해주세요.",
                                     message: "",
                                     buttonText: "확인",
                                     buttonAction: { })
                    return
                }
                self?.viewModel?.input.nickNameConfirm.onNext(nickname)
            }
            .disposed(by: disposeBag)
        
        passwordInsertView.textField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [weak self] _ in
                guard let password = self?.passwordInsertView.textField.text else { return }
                self?.viewModel?.input.password.onNext(password)
                self?.passwordCheckInsertView.textField.text = ""
                self?.passwordCheckInsertView.subTitleLabel.text = ""
            })
            .disposed(by: disposeBag)

        passwordCheckInsertView.textField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { [weak self] _ in
                guard let password = self?.passwordCheckInsertView.textField.text else { return }
                self?.viewModel?.input.passwordCheck.onNext(password)
            })
            .disposed(by: disposeBag)
        
        changeButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.changeButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        self.viewModel?.output.passwordValidation
            .subscribe(onNext: { [weak self] isValid in
                if !isValid {
                    self?.passwordCheckInsertView.textField.isEnabled = false
                    self?.showPopUp1(title: "비밀번호를 확인해주세요",
                                     message: "올바르지 않은 비밀번호 입니다.",
                                     buttonText: "확인", buttonAction: {
                        self?.passwordInsertView.textField.text = ""
                    })
                } else {
                    self?.passwordCheckInsertView.textField.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.output.passwordIsChecked
            .subscribe(onNext: { [weak self] isSame in
                print("isSame : \(isSame)")
                self?.passwordCheckInsertView.subTitleLabel.isHidden = false
                
                if isSame {
                    self?.passwordCheckInsertView.subTitleLabel.text = "비밀번호가 일치합니다"
                    self?.passwordCheckInsertView.subTitleLabel.textColor = .secondary

                } else {
                    self?.passwordCheckInsertView.subTitleLabel.text = "동일하지 않은 비밀번호입니다"
                    self?.passwordCheckInsertView.subTitleLabel.textColor = .primary
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.output.changeButtonEnabled
            .subscribe(onNext: { [weak self] isEnabled in
                self?.changeButton.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
    }
}

extension EditUserInfoViewController: MBTIElementViewControllerDelegate {
    
    func selectMBTI(mbti: String) {
        mbtiInsertView.textField.text = mbti
        self.viewModel?.input.mbti.onNext(mbti)
    }
}

// TODO: 추후 수정할 네트워크 관련 로직
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
//                        checkEnableNextButtonOrNot()
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
