//
//  EmailLoginViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/21.
//

import UIKit
import SnapKit
import Then

class EmailLoginViewController: UIViewController, AlertMessageDelegate {
    
    func okButtonTapped(from: String) {
        if from == "successEmailLogin" {
            print("============getData=========")
            getData()
        }
    }
    
    var isCheckButtonTapped = false
    let network = SignUpAPI()
    let userInfoNetwork = UserInfoAPI()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    private lazy var emailLoginLabel = UILabel().then {
        $0.text = "이메일로 로그인"
        $0.font = .systemFont(ofSize: 20.0, weight: .bold)
        $0.textColor = .blackTextColor
    }
    private lazy var idLabel = UILabel().then {
        $0.text = "아이디(이메일)"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .blackTextColor
    }
    
    private lazy var idTextField = UITextField().then {
        $0.placeholder = "이메일 주소를 입력해주세요"
    }
    
    private lazy var passwordLabel = UILabel().then {
        $0.text = "비밀번호"
    }
    private lazy var passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }
    
    private lazy var checkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "ic_check"), for: .normal)
        $0.addTarget(self, action: #selector(didTapCheckButton),for: .touchUpInside)
        $0.tintColor = .lightGray
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var keepLoginLabel = UILabel().then {
        $0.text = "로그인 상태 유지"
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    private lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .unabledButtonColor
        $0.setTitleColor(.unabledButtonTextColor, for: .normal)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapLoginButton),for: .touchUpInside)
    }
    
    private lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.blackTextColor, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        $0.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        
    }
    
    private lazy var noneUserLabel = UILabel().then {
        $0.text = "아직 F!nder 회원이 아니라면?"
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
        $0.textColor = .darkGrayTextColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        [checkButton,keepLoginLabel].forEach {
            $0.isHidden = true
        }
        layout()
        attribute()
        
        passwordTextField.delegate = self
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }

}

// MARK - Button actions
private extension EmailLoginViewController {
    @objc func didTapSignUpButton() {
        let nextVC = InsertUserInfoViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapLoginButton() {
       print("didTapLoginButton")
        guard let email = idTextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        loginButton.backgroundColor = .unabledButtonColor
        loginButton.setTitleColor(.unabledButtonTextColor, for: .normal)
        loginButton.isEnabled = false
        
        network.requestLogin(email: email,
                             password: password) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 이메일 로그인")
                    let accessToken = response.response?.accessToken
                    UserDefaults.standard.set(accessToken, forKey: "accessToken")
                    DispatchQueue.main.async {
                        self.presentCutomAlertVC(target: "successEmailLogin", title: "로그인 성공", message: "로그인에 성공하였습니다.")
                        
                    }
                } else {
                    print("실패 : 이메일 로그인")
                    DispatchQueue.main.async {
                        let errorMessage = response.errorResponse?.errorMessages[0]
                        self.presentCutomAlertVC(target: "emailLogin", title: "로그인 실패", message: errorMessage!)
                        
                    }
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
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

// MARK - TextFieldDelegate
extension EmailLoginViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            checkEverythingFilled()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        checkEverythingFilled()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        checkEverythingFilled()
        self.view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        checkEverythingFilled()
        return true
    }
    
    func checkEverythingFilled() {
        if idTextField.hasText && passwordTextField.hasText {
            loginButton.isEnabled = true
            loginButton.setTitleColor(.white, for: .normal)
            loginButton.backgroundColor = .mainTintColor
        } else {
            loginButton.backgroundColor = .unabledButtonColor
            loginButton.setTitleColor(.unabledButtonTextColor, for: .normal)
            loginButton.isEnabled = false
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
        [idTextField,passwordTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.layer.borderColor = UIColor.textFieldBorder.cgColor
            $0.layer.borderWidth = 1.0
            $0.addLeftPadding(padding: 20.0)
            $0.delegate = self
        }
    }
}
