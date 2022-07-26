//
//  InsertUserInfoViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/22.
//

import UIKit
import SnapKit
import Then

class InsertUserInfoViewController: UIViewController, UITextFieldDelegate, AlertMessageDelegate {
    func okButtonTapped(from: String) {
        if from == "email" {
            self.codeAuthButton.isEnabled = true
            self.codeAuthButton.setTitleColor(.white, for: .normal)
            self.codeAuthButton.backgroundColor = .mainTintColor
        } else if from == "auth" {
            
        }
    }
    
    let network = SignUpAPI()
    var passwordIsSame = false {
        didSet {
            if passwordIsSame {
                checkEnableNextButtonOrNot()
            }
        }
    }
    
    var emailAuth = false {
        didSet {
            if emailAuth {
                checkEnableNextButtonOrNot()
            }
        }
    }
    
    var codeAuth = false {
        didSet {
            if codeAuth {
                checkEnableNextButtonOrNot()
            }
        }
    }
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private lazy var headerTitle = UILabel().then {
        $0.text = "회원가입"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textAlignment = .center
    }
    
    private lazy var insertUserInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "signin_step1_orange")
    }
    
    private lazy var insertUserInfoLabel = UILabel().then {
        $0.text = "정보 입력"
        $0.textColor = .mainTintColor
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textAlignment = .center
    }
    
    private lazy var setupProfileImageView = UIImageView().then {
        $0.image = UIImage(named: "signin_step2_gray")
    }
    
    private lazy var setupProfileLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.textColor = .lightGrayTextColor
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textAlignment = .center
    }
    
    private lazy var completeSignUpImageView = UIImageView().then {
        $0.image = UIImage(named: "signin_step3_gray")
    }
    
    private lazy var completeSignUpLabel = UILabel().then {
        $0.text = "가입완료"
        $0.textColor = .lightGrayTextColor
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textAlignment = .center
    }
    
    private lazy var caretLeftImageView1 = UIImageView().then {
        $0.image = UIImage(named: "btn_caretleft_bold")
    }
    
    private lazy var caretLeftImageView2 = UIImageView().then {
        $0.image = UIImage(named: "btn_caretleft_bold")
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.setTitleColor(.unabledButtonTextColor, for: .normal)
        $0.backgroundColor = .unabledButtonColor
        $0.isEnabled = false
        // TODO : for test
//        $0.isEnabled = true
        $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    private lazy var idLabel = UILabel().then {
        $0.text = "아이디(이메일)"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .blackTextColor
    }
    
    private lazy var idTextField = UITextField().then {
        $0.placeholder = "이메일을 인증해주세요"
    }
    
    private lazy var requestAuthButton = UIButton().then {
        $0.setTitle("인증요청", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainTintColor
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.addTarget(self, action: #selector(didTapRequestAuthButton), for: .touchUpInside)
    }
    
    private lazy var codeLabel = UILabel().then {
        $0.text = "코드번호"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .blackTextColor
    }
    
    private lazy var codeTextField = UITextField().then {
        $0.placeholder = "코드번호를 입력해주세요"
    }
    
    private lazy var codeAuthButton = UIButton().then {
        $0.setTitle("인증확인", for: .normal)
        $0.setTitleColor(UIColor(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0), for: .normal)
        $0.backgroundColor = UIColor(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapCodeAuthButton), for: .touchUpInside)
    }
    
    private lazy var passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .blackTextColor
    }
    private lazy var passwordTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
    }
    
    private lazy var passwordInfoLabel = UILabel().then {
        $0.text = "영문, 숫자 포함 8~ 16자"
        $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
    }
    
    private lazy var passwordCheckTextField = UITextField().then {
        $0.placeholder = "비밀번호를 재입력해주세요"
        $0.isSecureTextEntry = true
    }
    
    private lazy var passwordCheckLabel = UILabel().then {
        $0.text = "비밀번호를 다시 한번 입력해주세요"
        $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        layout()
        attribute()
        
        passwordCheckTextField.delegate = self
        passwordCheckTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

extension InsertUserInfoViewController {
    
    func checkEnableNextButtonOrNot() {
        if passwordIsSame && emailAuth && codeAuth {
            nextButton.isEnabled = true
            nextButton.backgroundColor = .mainTintColor
            nextButton.setTitleColor(.white, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.setTitleColor(.unabledButtonTextColor, for: .normal)
            nextButton.backgroundColor = .unabledButtonColor
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let password = passwordTextField.text else {
            return
        }
        
        if password == textField.text {
            passwordCheckLabel.text = "비밀번호가 일치합니다"
            passwordCheckLabel.textColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
            passwordIsSame = true
            print("일치")
        } else {
            print("불일치")
            passwordCheckLabel.text = "동일하지 않은 비밀번호입니다"
            passwordCheckLabel.textColor = .mainTintColor
            passwordIsSame = false
        }
    }
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// MARK : - Button Action
private extension InsertUserInfoViewController {
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didTapNextButton() {
        let nextVC = SetUpProfileViewController()
        nextVC.email = idTextField.text ?? "nil"
        nextVC.password = passwordTextField.text ?? "nil"
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // 인증 요청
    @objc func didTapRequestAuthButton() {
        print("didTapRequestQuthButton")
        
        guard let email = idTextField.text else {
            return
        }
        
        requestAuthButton.isEnabled = false
        requestAuthButton.backgroundColor = .unabledButtonColor
        requestAuthButton.setTitleColor(.unabledButtonTextColor, for: .normal)
        
        network.requestAuthEmail(email: email) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    DispatchQueue.main.async {
                        self.presentCutomAlertVC(target: "email",
                                            title: "코드번호 발송",
                                            message: "이메일로 코드번호가 발송되었습니다.")
                        
                        emailAuth = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presentCutomAlertVC(target: "email",
                                            title: "코드번호 발송 실패",
                                            message: "코드번호 발송을 실패했습니다.")
                        requestAuthButton.isEnabled = true
                        requestAuthButton.backgroundColor = .mainTintColor
                        requestAuthButton.setTitleColor(.white, for: .normal)
                        emailAuth = false
                        
                    }
                    print("이메일 확인")
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    // 인증 확인
    @objc func didTapCodeAuthButton() {
        print("didTapCodeAuthButton")
        
        guard let email = idTextField.text,
        let code = codeTextField.text else {
            
            return
        }
        network.requestCodeAuth(code: code, email: email) { [self] result in
            

            switch result {
            case let .success(response) :
                
                if response.success {
                    DispatchQueue.main.async {
                        codeAuthButton.isEnabled = false
                        codeAuthButton.backgroundColor = .unabledButtonColor
                        codeAuthButton.setTitleColor(.unabledButtonTextColor, for: .normal)
                        self.presentCutomAlertVC(target: "auth",
                                            title: "이메일 인증 완료",
                                            message: "인증되었습니다.")
                        
                        codeAuth = true
                    }
                } else {
                    DispatchQueue.main.async { [self] in
                        presentCutomAlertVC(target: "auth",
                                            title: "이메일 인증 실패",
                                            message: "이메일 인증을 실패했습니다")
                        
                        codeAuthButton.isEnabled = true
                        codeAuthButton.backgroundColor = .mainTintColor
                        codeAuthButton.setTitleColor(.white, for: .normal)
                        codeAuth = false
                    }
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func presentCutomAlertVC(target:String, title:String, message:String) {
        let nextVC = AlertMessageViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
}

private extension InsertUserInfoViewController {
    func layout() {
        [backButton,
         headerTitle,
         insertUserInfoImageView,
         insertUserInfoLabel,
         setupProfileImageView,
         setupProfileLabel,
         completeSignUpImageView,
         completeSignUpLabel,
         caretLeftImageView1,
         caretLeftImageView2,
         nextButton,
         idLabel,
         idTextField,
         requestAuthButton,
         codeLabel,
         codeTextField,
         codeAuthButton,
         passwordLabel,
         passwordTextField,
         passwordCheckTextField,
         passwordInfoLabel,
         passwordCheckLabel].forEach {
            self.view.addSubview($0)
        }
    }
    
    func attribute() {
        let safeArea = self.view.safeAreaLayoutGuide
        let imageWidthAndHeight : CGFloat = 60.0
        let caretWidthAndHeight : CGFloat = 24.0
        
        backButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(safeArea.snp.top).inset(12.0)
        }
        
        headerTitle.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        setupProfileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerTitle.snp.bottom).offset(38.0)
            $0.height.width.equalTo(imageWidthAndHeight)
        }
        
        setupProfileLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(setupProfileImageView.snp.bottom).offset(12.0)
        }
        
        caretLeftImageView1.snp.makeConstraints {
            $0.width.height.equalTo(caretWidthAndHeight)
            $0.centerY.equalTo(setupProfileImageView)
            $0.trailing.equalTo(setupProfileImageView.snp.leading).offset(-12.0)
        }
        
        caretLeftImageView2.snp.makeConstraints {
            $0.width.height.equalTo(caretWidthAndHeight)
            $0.centerY.equalTo(setupProfileImageView)
            $0.leading.equalTo(setupProfileImageView.snp.trailing).offset(12.0)
        }
        
        insertUserInfoImageView.snp.makeConstraints {
            $0.centerY.equalTo(setupProfileImageView)
            $0.width.height.equalTo(imageWidthAndHeight)
            $0.trailing.equalTo(caretLeftImageView1.snp.leading).offset(-13.0)
        }
        
        insertUserInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(setupProfileLabel)
            $0.centerX.equalTo(insertUserInfoImageView)
        }
        
        completeSignUpLabel.snp.makeConstraints {
            $0.centerY.equalTo(setupProfileLabel)
            $0.centerX.equalTo(completeSignUpImageView)
        }
        
        completeSignUpImageView.snp.makeConstraints {
            $0.width.height.equalTo(imageWidthAndHeight)
            $0.centerY.equalTo(setupProfileImageView)
            $0.leading.equalTo(caretLeftImageView2.snp.trailing).offset(13.0)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).inset(26.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(54.0)
        }
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(insertUserInfoLabel.snp.bottom).offset(12.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        idTextField.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(idLabel)
        }
        
        requestAuthButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.0)
            $0.leading.equalTo(idTextField.snp.trailing).offset(12.0)
            $0.width.equalTo(71.0)
            $0.centerY.equalTo(idTextField)
            $0.height.equalTo(54.0)
        }
        
        codeLabel.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(8.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        codeTextField.snp.makeConstraints {
            $0.top.equalTo(codeLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(codeLabel)
//            $0.trailing.equalTo(safeArea.snp.trailing).inset(24.0)
        }
        
        codeAuthButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.0)
            $0.leading.equalTo(codeTextField.snp.trailing).offset(12.0)
            $0.width.equalTo(71.0)
            $0.centerY.equalTo(codeTextField)
            $0.height.equalTo(54.0)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.top.equalTo(codeTextField.snp.bottom).offset(8.0)
            $0.leading.equalTo(idLabel)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(24.0)
        }
        
        passwordInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(idLabel)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8.0)
        }
        
        passwordCheckTextField.snp.makeConstraints {
            $0.top.equalTo(passwordInfoLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(idLabel)
            $0.trailing.equalTo(safeArea.snp.trailing).inset(24.0)
        }
        
        passwordCheckLabel.snp.makeConstraints {
            $0.leading.equalTo(idLabel)
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(8.0)
        }
        
        [idTextField,codeTextField,passwordTextField,passwordCheckTextField].forEach {
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.layer.borderColor = UIColor.textFieldBorder.cgColor
            $0.layer.borderWidth = 1.0
            $0.addLeftPadding(padding: 20.0)
            $0.delegate = self
        }
    }
}

extension Dictionary {
  func percentEncoded() -> Data? {
    return map { key, value in
      let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
      return escapedKey + "=" + escapedValue
    }
    .joined(separator: "&")
    .data(using: .utf8)
  }
}

extension CharacterSet {
  static let urlQueryValueAllowed: CharacterSet = {
    let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
    let subDelimitersToEncode = "!$&'()*+,;="

    var allowed = CharacterSet.urlQueryAllowed
    allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
    return allowed
  }()
}
