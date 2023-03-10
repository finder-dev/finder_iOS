//
//  SignUpViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/21.
//

import UIKit
import SnapKit
import Then

class SetUpProfileViewController: UIViewController, DialogViewControllerDelegate, AlertMessageDelegate {
    func okButtonTapped(from: String) {
       
    }
    
    let network = SignUpAPI()
    var isnicknameChecked = false {
        didSet {
            enableNextButton()
        }
    }
    var isCheckButtonTapped = false {
        didSet {
            enableNextButton()
        }
    }
    
    var email: String?
    var password: String?
    
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
        $0.image = UIImage(named: "signin_step1_gray")
    }
    
    private lazy var insertUserInfoLabel = UILabel().then {
        $0.text = "정보 입력"
        $0.textColor = .lightGrayTextColor
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textAlignment = .center
    }
    
    private lazy var setupProfileImageView = UIImageView().then {
        $0.image = UIImage(named: "signin_step2_orange")
    }
    
    private lazy var setupProfileLabel = UILabel().then {
        $0.text = "프로필 설정"
        $0.textColor = .mainTintColor
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
    
    private lazy var MBTILabel = UILabel().then {
        $0.text = "MBTI"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .black1
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
    
    private lazy var nickNameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textColor = .black1
    }
    
    private lazy var nickNameTextField = UITextField().then {
        $0.placeholder = "6자 이내로 적어주세요"
        $0.addLeftPadding(padding: 20.0)
        $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        $0.layer.borderColor = UIColor.textFieldBorder.cgColor
        $0.layer.borderWidth = 1.0
    }
    
    private lazy var nickNameCheckButton = UIButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainTintColor
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.addTarget(self, action: #selector(didTapNickNameCheckButton), for: .touchUpInside)
    }
    
    private lazy var checkButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "ic_check"), for: .normal)
        $0.addTarget(self, action: #selector(didTapCheckButton),for: .touchUpInside)
        $0.tintColor = .lightGray
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
    }
    
    private lazy var serviceTermAgreeLabel = UILabel().then {
        $0.text = "개인정보취급방침 및 서비스 약관에 동의 합니다."
        $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        $0.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    private lazy var showServiceTerm = UIButton().then{
        $0.setImage(UIImage(named: "btn_expandmore_blue"), for: .normal)
        $0.addTarget(self, action: #selector(didTapShowServiceTermButton), for: .touchUpInside)
    }
   
    private lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.setTitleColor(.unabledButtonTextColor, for: .normal)
        $0.backgroundColor = .unabledButtonColor
        $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setup()
        layout()
        attribute()
        
        nickNameTextField.delegate = self
        nickNameCheckButton.isHidden = true
    }
    
    func sendValue(value: String) {
        MBTITextField.text = value
        print("from dialogView - \(value)")
        enableNextButton()
    }
    
}

// 키보드 내림 추가
extension SetUpProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// MARK : - Button Action
private extension SetUpProfileViewController {
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapNextButton() {
        
        guard let email = email else { return }
        guard let password = password else { return }
        guard let mbti = MBTITextField.text else { return }
        print(mbti)
        guard let nickname = nickNameTextField.text else { return }
        
        network.requestSignUp(email: email,
                              password: password,
                              mbti: mbti,
                              nickname: nickname) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("회원가입 성공")
                    DispatchQueue.main.async {
                        let nextVC = CompleteSignUpViewController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                } else {
                    DispatchQueue.main.async {
                        let errorMessage = response.errorResponse?.errorMessages[0]
                        self.presentCutomAlertVC(target: "setup", title: "회원가입 실패", message: errorMessage!)
                    }
//                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    @objc func didTapNickNameCheckButton() {
//        print("didTapNickNameCheckButton")
//        guard let nickname = nickNameTextField.text else {
//            return
//        }
//        network.requestCheckNickname(nickname: nickname) { result in
//            switch result {
//            case let .success(response) :
//                if response.success {
//                    print("닉네임 사용 가능")
//                    self.isnicknameChecked = true
//                } else {
//                    print(response.errorResponse?.errorMessages)
//                    self.isnicknameChecked = false
//                }
//            case .failure(_):
//                print("오류")
//            }
//        }
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
    
    @objc func didTapShowServiceTermButton() {
        let nextVC = WebViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapMBTITextField() {
        print("didTapMBTITextFiedl")
        let nextVC = DialogViewController()
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    // 다음 버튼 활성화
    func enableNextButton() {
        DispatchQueue.main.async { [self] in
            guard let mbti = MBTITextField.text else { return }
            
            if !mbti.isEmpty && isCheckButtonTapped {
                nextButton.backgroundColor = .orange
                nextButton.setTitleColor(.white, for: .normal)
                nextButton.isEnabled = true
            } else {
                nextButton.backgroundColor = .unabledButtonColor
                nextButton.setTitleColor(.unabledButtonTextColor, for: .normal)
                nextButton.isEnabled = false
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
}

private extension SetUpProfileViewController {
    
    func setup() {
        
    }
    
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
         MBTILabel,
         MBTITextField,
         nickNameLabel,
         nickNameTextField,
         nickNameCheckButton,
         checkButton,
         serviceTermAgreeLabel,
         showServiceTerm].forEach {
            self.view.addSubview($0)
        }
        
        
        MBTILabel.snp.makeConstraints {
            $0.top.equalTo(insertUserInfoLabel.snp.bottom).offset(36.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        MBTITextField.snp.makeConstraints {
            $0.top.equalTo(MBTILabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(MBTILabel)
            $0.trailing.equalToSuperview().inset(24.0)
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(MBTITextField.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(24.0)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        nickNameCheckButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24.0)
            $0.leading.equalTo(nickNameTextField.snp.trailing).offset(12.0)
            $0.width.equalTo(71.0)
            $0.centerY.equalTo(nickNameTextField)
            $0.height.equalTo(54.0)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalTo(nickNameTextField.snp.bottom).offset(22.0)
            $0.leading.equalTo(nickNameLabel)
            $0.height.width.equalTo(24.0)
        }
        
        serviceTermAgreeLabel.snp.makeConstraints {
            $0.centerY.equalTo(checkButton)
            $0.leading.equalTo(checkButton.snp.trailing).offset(8.0)
        }
        
        showServiceTerm.snp.makeConstraints {
            $0.centerY.equalTo(checkButton)
            $0.width.height.equalTo(24.0)
            $0.trailing.equalToSuperview().inset(24.0)
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
        
    }
}
