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
    
    var viewModel: SignUpViewModel?
    
    init(viewModel: SignUpViewModel) {
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
                if self?.signUpProcess == .insertData {
                    // 정보 입력 화면의 다음 버튼
                    self?.signUpProcess = .settingProfile
                } else {
                    // 프로필 설정 화면의 다음 버튼
                    self?.signUpProcess = .completeSignUp
                }
            })
            .disposed(by: disposeBag)
        
        idInsertView.requestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextButton.isEnabled = true
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
        
        idInsertView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] id in
                self?.idInsertView.requestButton.isEnabled = id.count > 0 ? true : false
            })
            .disposed(by: disposeBag)
        
        idInsertView.requestButton.rx.tap
            .bind { [weak self] _ in
                guard let id = self?.idInsertView.textField.text else { return }
                self?.viewModel?.input.idConfirmTrigger.onNext(id)
            }
            .disposed(by: disposeBag)
        
        codeInsertView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] code in
                self?.codeInsertView.requestButton.isEnabled = code.count > 0 ? true : false
            })
            .disposed(by: disposeBag)
    
        codeInsertView.requestButton.rx.tap
            .bind { [weak self] _ in
                guard let code = self?.codeInsertView.textField.text else { return }
                self?.viewModel?.input.codeConfirmTrigger.onNext(code)
            }
            .disposed(by: disposeBag)
        
        passwordInsertView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] password in
                self?.viewModel?.input.password.onNext(password)
                self?.passwordCheckInsertView.textField.text = ""
                self?.passwordCheckInsertView.subTitleLabel.text = ""
            }
            .disposed(by: disposeBag)
        
        passwordCheckInsertView.textField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { [weak self] password in
                self?.viewModel?.input.passwordCheck.onNext(password)
            }
            .disposed(by: disposeBag)
        
        nicknameInsertView.requestButton.rx.tap
            .bind { [weak self] _ in
                guard let nickName = self?.nicknameInsertView.textField.text else { return }
                self?.viewModel?.input.nickNameConfirmTrigger.onNext(nickName)
            }
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        self.viewModel?.output.passwordValidation
            .subscribe(onNext: { isValid in
                if !isValid {
                    print("비밀번호 유효하지 않음")
                } else {
                    print("비밀번호 유효")
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.output.passwordIsChecked
            .subscribe(onNext: { [weak self] isSame in
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
    }
}

extension SignUpViewController: MBTIElementViewControllerDelegate {
    func selectMBTI(mbti: String) {
        self.mbtiInsertView.textField.text = mbti
        self.viewModel?.input.mbti.onNext(mbti)
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
