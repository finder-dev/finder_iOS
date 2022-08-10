//
//  EmailLoginViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/21.
//

import UIKit
import SnapKit
import Then

import ReactorKit
import RxSwift
import RxCocoa
import RxGesture

/*
 * finder에 가입한 아이디로 로그인
 */
class EmailLoginViewController: UIViewController, View {

    var isCheckButtonTapped = false
    let network = SignUpAPI()
    let userInfoNetwork = UserInfoAPI()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    var emailLoginLabel = UILabel()
    var idLabel = UILabel()
    var idTextField = UITextField()
    var passwordLabel = UILabel()
    var passwordTextField = UITextField()
    var keepLoginLabel = UILabel()
    var noneUserLabel = UILabel()
    
    
    private lazy var checkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "ic_check"), for: .normal)
        $0.addTarget(self, action: #selector(didTapCheckButton),for: .touchUpInside)
        $0.tintColor = .lightGray
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .unabledButtonColor
        $0.setTitleColor(.unabledButtonTextColor, for: .normal)
        $0.isEnabled = false
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.blackTextColor, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
    }
    
    var disposeBag = DisposeBag()
    
    func bind(reactor: EmailLoginViewModel) {
        
        // MARK : - Action
        // 1. textfield 두개 활성화 감지 -> 로그인 버튼 활성화
        // 2. 로그인 버튼 탭 -> 로그인 API
        idTextField.rx.controlEvent([.editingChanged])
            .map {
                self.idTextField.hasText ?
                Reactor.Action.IdTextFieldIsFilled(true) : Reactor.Action.IdTextFieldIsFilled(false)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent([.editingChanged])
            .map {
                self.passwordTextField.hasText ?
                Reactor.Action.passwordTextFieldIsFilled(true) :
                Reactor.Action.passwordTextFieldIsFilled(false)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .filter { self.idTextField.hasText && self.passwordTextField.hasText }
            .do(onNext: {
                self.disableLoginButton()
            })
            .map {
                Reactor.Action.tapLoginButton( self.idTextField.text!,
                                               self.passwordTextField.text!)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 키보드의 return 누른 경우 키보드내리기
        [idTextField,passwordTextField].forEach {
            $0.rx.controlEvent([.editingDidEndOnExit])
                .subscribe { _ in
                }.disposed(by: disposeBag)
        }

        // 화면 탭 시 키보드 내리기
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe { _ in
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        
        // MARK : - State
        
        // 로그인 버튼 활성화
        reactor.state
            .map { $0.isLoginButtonEnabled }
            .distinctUntilChanged()
            .subscribe (onNext:{
                self.updateButtonState(enable: $0)
            })
            .disposed(by: disposeBag)
        
        // 로그인 성공 -> 토큰 저장, 화면 전환
        reactor.state.map { $0.userToken }
            .filter { $0 != "" }
            .distinctUntilChanged()
            .subscribe(onNext: { token in
                UserDefaults.standard.set(token, forKey: "accessToken")
                DispatchQueue.main.async {
                    self.presentCutomAlertVC(target: "successEmailLogin", title: "로그인 성공", message: "로그인에 성공하였습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        // 로그인 실패 -> 에러메시지
        reactor.state.map { $0.errorMessage }
            .filter { $0 != "" }
            .distinctUntilChanged()
            .subscribe(onNext: { message in
                print("실패 : 이메일 로그인")
                DispatchQueue.main.async {
                    self.presentCutomAlertVC(target: "emailLogin", title: "로그인 실패", message: message)
                    self.enableLoginButton()
                }
            })
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = EmailLoginViewModel()
       
        [checkButton,keepLoginLabel].forEach {
            $0.isHidden = true
        }
        layout()
        attribute()
    }
}

extension EmailLoginViewController: AlertMessageDelegate {
    func okButtonTapped(from: String) {
        if from == "successEmailLogin" {
            print("============getData=========")
            getData()
        } else if from == "emailLogin" {
            loginButton.backgroundColor = .mainTintColor
            loginButton.setTitleColor(.white, for: .normal)
            loginButton.isEnabled = true
        }
    }
}

// MARK - Button actions
private extension EmailLoginViewController {
    
    @objc func didTapSignUpButton() {
        let nextVC = InsertUserInfoViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func updateButtonState(enable: Bool) {
        if enable {
            enableLoginButton()
        } else {
            disableLoginButton()
        }
    }
    
    func enableLoginButton() {
        loginButton.backgroundColor = .mainTintColor
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.isEnabled = true
    }

    func disableLoginButton() {
        loginButton.backgroundColor = .unabledButtonColor
        loginButton.setTitleColor(.unabledButtonTextColor, for: .normal)
        loginButton.isEnabled = false
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapCheckButton() {
        isCheckButtonTapped = isCheckButtonTapped ? false : true
        if checkButton.tintColor == .lightGray {
            checkButton.tintColor = .orange
            checkButton.layer.borderColor = UIColor.orange.cgColor
        } else {
            checkButton.tintColor = .lightGray
            checkButton.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    // AlertVC 띄움
    func presentCutomAlertVC(target:String, title:String, message:String) {
        let nextVC = AlertMessageViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    func getData() {
        userInfoNetwork.requestUserInfo { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 사용자 정보 가져오기")
                    
                    let userId = response.response?.userId ?? 0
                    let userEmail = response.response?.email ?? "nil"
                    let userMBTI = response.response?.mbti ?? "nil"
                    let userNickName = response.response?.nickname ?? "nil"
    
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set(userEmail, forKey: "userEmail")
                    UserDefaults.standard.set(userMBTI, forKey: "userMBTI")
                    UserDefaults.standard.set(userNickName, forKey: "userNickName")
                    
                    DispatchQueue.main.async {
                        let nextVC = MainTabBarController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                } else {
                    print("실패 : 사용자 정보 가져오기")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}

private extension EmailLoginViewController {
    func layout() {
        
        [backButton,
         emailLoginLabel,
         idLabel,
         idTextField,
         passwordLabel,
         passwordTextField,
         checkButton,
         keepLoginLabel,
         loginButton,
         noneUserLabel,
         signUpButton].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        backButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(safeArea.snp.top).inset(12.0)
        }
    
        emailLoginLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(49.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(emailLoginLabel.snp.bottom).offset(50.0)
            $0.leading.equalTo(emailLoginLabel)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(emailLoginLabel)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(24.0)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(16.0)
            $0.leading.equalTo(emailLoginLabel)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(emailLoginLabel)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(24.0)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8.0)
            $0.leading.equalTo(emailLoginLabel)
            $0.height.width.equalTo(24.0)
        }
        
        keepLoginLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkButton)
            $0.leading.equalTo(checkButton.snp.trailing).offset(8.0)
        }

        loginButton.snp.makeConstraints {
            $0.top.equalTo(checkButton.snp.bottom).offset(34.0)
            $0.leading.equalTo(safeArea.snp.leading).inset(24.0)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(24.0)
            $0.height.equalTo(54.0)
        }

        noneUserLabel.snp.makeConstraints {
            $0.top.equalTo(loginButton.snp.bottom).offset(16.0)
            $0.leading.equalTo(emailLoginLabel)
        }

        signUpButton.snp.makeConstraints {
            $0.leading.equalTo(noneUserLabel.snp.trailing).offset(8.0)
            $0.centerY.equalTo(noneUserLabel)
        }
    }
    
    func attribute() {
        
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
        [idTextField,passwordTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.layer.borderColor = UIColor.textFieldBorder.cgColor
            $0.layer.borderWidth = 1.0
            $0.addLeftPadding(padding: 20.0)
//            $0.delegate = self
        }
        
        emailLoginLabel.text = "이메일로 로그인"
        emailLoginLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        emailLoginLabel.textColor = .blackTextColor
        
        idLabel.text = "아이디(이메일)"
        idLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        idLabel.textColor = .blackTextColor
        
        idTextField.placeholder = "이메일 주소를 입력해주세요"
        passwordLabel.text = "비밀번호"
        passwordTextField.placeholder = "비밀번호를 입력해주세요"
        passwordTextField.isSecureTextEntry = true
       
        keepLoginLabel.text = "로그인 상태 유지"
        keepLoginLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        keepLoginLabel.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
        
        noneUserLabel.text = "아직 F!nder 회원이 아니라면?"
        noneUserLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        noneUserLabel.textColor = .darkGrayTextColor
    }
}
