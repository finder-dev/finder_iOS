//
//  EditUserInfoViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import UIKit
import SnapKit
import Then

class EditUserInfoViewController: UIViewController, DialogViewControllerDelegate, AlertMessageDelegate {
    
    func okButtonTapped(from: String) {
        if from == "DuplicatedNickName" {
            nickNameCheckButton.setTitleColor(.white, for: .normal)
            nickNameCheckButton.backgroundColor = .mainTintColor
            nickNameCheckButton.isEnabled = true
        }
    }
    
    let headerView = UIView()
    let nickNameLabel = UILabel()
    let nickNameTextField = UITextField()
    let nickNameCheckButton = UIButton()
    let passswordLabel = UILabel()
    let passwordTextField = UITextField()
    let passwordTextField2 = UITextField()
    let passwordInfoLabel = UILabel()
    let passwordCheckLabel = UILabel()
    let idCheckButton = UIButton()
    let mbtiLabel = UILabel()
    
    let nextButton = UIButton()
    let userAPI = UserInfoAPI()
    
    var passwordIsSame = false {
        didSet {
            checkEnableNextButtonOrNot()
        }
    }
    
    private lazy var MBTITextField = UITextField().then {
        let button = UIButton()
        button.setImage(UIImage(named: "btn_caretleft_gray"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
        $0.rightView = button
        $0.rightViewMode = .always
        $0.placeholder = "MBTI를 선택해주세요"
        $0.addLeftPadding(padding: 20.0)
        $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        $0.layer.borderColor = UIColor.textFieldBorder.cgColor
        $0.layer.borderWidth = 1.0
        $0.addTarget(self, action: #selector(didTapMBTITextField), for: .touchDown)
    }
    
    @objc func didTapMBTITextField() {
        print("didTapMBTITextFiedl")
        let nextVC = DialogViewController()
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }

    func sendValue(value: String) {
        MBTITextField.text = value
        checkEnableNextButtonOrNot()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        setupHeaderView()
        
        [passwordTextField,passwordTextField2].forEach {
            $0.delegate = self
//            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
//        passwordTextField2.delegate = self
        passwordTextField2.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
}

extension EditUserInfoViewController: UITextFieldDelegate {
    
    func checkEnableNextButtonOrNot() {
        print(" checkEnableNextButtonOrNo")
        guard let mbti = MBTITextField.text else {
            return
        }
        
        guard let password = passwordTextField.text else {
            return
        }
        
        
        if password.isEmpty {
            if nickNameCheckButton.isEnabled == false && !mbti.isEmpty {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .mainTintColor
                nextButton.setTitleColor(.white, for: .normal)
            } else {
                nextButton.isEnabled = false
                nextButton.setTitleColor(.unabledButtonTextColor, for: .normal)
                nextButton.backgroundColor = .unabledButtonColor
            }
        } else {
            if nickNameCheckButton.isEnabled == false && !mbti.isEmpty && passwordIsSame {
                nextButton.isEnabled = true
                nextButton.backgroundColor = .mainTintColor
                nextButton.setTitleColor(.white, for: .normal)
            } else {
                nextButton.isEnabled = false
                nextButton.setTitleColor(.unabledButtonTextColor, for: .normal)
                nextButton.backgroundColor = .unabledButtonColor
            }
        }
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        checkEnableNextButtonOrNot()
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


private extension EditUserInfoViewController {
    func layout() {
        [headerView,
         nickNameLabel,
         nickNameTextField,
         nickNameCheckButton,
         passswordLabel,
         passwordTextField,
         passwordTextField2,
         passwordInfoLabel,
         mbtiLabel,
         nextButton,
         MBTITextField,
         passwordCheckLabel].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(headerView.snp.bottom).offset(16.0)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel)
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8.0)
        }
        
        nickNameCheckButton.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.leading.equalTo(nickNameTextField.snp.trailing).offset(12.0)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(16.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        MBTITextField.snp.makeConstraints {
            $0.top.equalTo(mbtiLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(mbtiLabel)
            $0.centerX.equalToSuperview()
        }
        
        passswordLabel.snp.makeConstraints {
            $0.top.equalTo(MBTITextField.snp.bottom).offset(16.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel)
            $0.top.equalTo(passswordLabel.snp.bottom).offset(8.0)
            $0.centerX.equalToSuperview()
        }
        
        passwordInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(passwordTextField)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8.0)
        }
        
        passwordTextField2.snp.makeConstraints {
            $0.top.equalTo(passwordInfoLabel.snp.bottom).offset(16.0)
            $0.leading.trailing.equalTo(passwordTextField)
        }
        
        passwordCheckLabel.snp.makeConstraints {
            $0.leading.equalTo(passwordTextField)
            $0.top.equalTo(passwordTextField2.snp.bottom).offset(8.0)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(26.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(54.0)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
        [nickNameLabel,passswordLabel,mbtiLabel].forEach {
            $0.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.textColor = .blackTextColor
        }
        
        nickNameLabel.text = "닉네임"
        passswordLabel.text = "비밀번호"
        mbtiLabel.text = "MBTI"
        
        [nickNameCheckButton,idCheckButton].forEach {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .mainTintColor
            $0.widthAnchor.constraint(equalToConstant: 71.0).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        }
        
        nickNameCheckButton.setTitle("중복확인", for: .normal)
        nickNameCheckButton.addTarget(self, action: #selector(didTapNickNameCheckButton), for: .touchUpInside)
        
        idCheckButton.setTitle("인증요청", for: .normal)
        idCheckButton.addTarget(self, action: #selector(didTapIdCheckButton), for: .touchUpInside)

        [nickNameTextField,passwordTextField,passwordTextField2].forEach {
            $0.addLeftPadding(padding: 20.0)
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.layer.borderColor = UIColor.textFieldBorder.cgColor
            $0.layer.borderWidth = 1.0
        }
        
        passwordInfoLabel.text = "영문, 숫자 포함 8~ 16자"
        passwordInfoLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        passwordInfoLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        
        passwordCheckLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        
        nickNameTextField.placeholder = "6자 이내로 적어주세요"
        passwordTextField.placeholder = ""
        
        nextButton.setTitle("변경", for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        nextButton.setTitleColor(.unabledButtonTextColor, for: .normal)
        nextButton.backgroundColor = .unabledButtonColor
//        nextButton.isEnabled = false
        // TODO : for test
        nextButton.isEnabled = true
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    @objc func didTapNickNameCheckButton() {
        print("didTapNickNameCheckButton")
        guard let nickName = nickNameTextField.text else {
            return
        }
        nickNameCheckButton.setTitleColor(.unabledButtonTextColor, for: .normal)
        nickNameCheckButton.backgroundColor = .unabledButtonColor
        nickNameCheckButton.isEnabled = false
        
        userAPI.requestCheckNickname(nickname: nickName) { [self] result in
            switch result {
            case let .success(response) :
                
                if response.success {
                    guard let response = response.response else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        presentCutomAlertVC(target: "CheckNickname", title: response.message, message: "")
                        checkEnableNextButtonOrNot()
                    }
                } else {
                    guard let error = response.errorResponse else {
                        return
                    }
                    
//                    print(error.errorMessages)
                    DispatchQueue.main.async {
                        presentCutomAlertVC(target: "DuplicatedNickName", title: "닉네임 사용 불가", message: error.errorMessages[0])
                    }
                }
                
            case .failure(_):
                print("오류")
            }
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
    
    @objc func didTapIdCheckButton() {
        print("didTapIdCheckButton")
    }
    @objc func didTapNextButton() {
        print("didTapNextButton")
    }
}

private extension EditUserInfoViewController {
    func setupHeaderView() {
        
        let headerLabel = UILabel()
        let backButton = UIButton()
        
        [headerLabel,backButton].forEach {
            headerView.addSubview($0)
        }
        
        headerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
        }

        headerLabel.text = "개인 정보 수정"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
        
        backButton.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
