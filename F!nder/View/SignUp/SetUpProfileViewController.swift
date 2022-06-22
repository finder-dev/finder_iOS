//
//  SignUpViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/21.
//

import UIKit
import SnapKit
import Then

class SetUpProfileViewController: UIViewController {
    
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
        $0.textColor = .mainTintColor
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.textAlignment = .center
    }
    
    private lazy var setupProfileImageView = UIImageView().then {
        $0.image = UIImage(named: "signin_step2_orange")
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
        $0.setTitleColor(.darkGrayTextColor, for: .normal)
        $0.backgroundColor = .lightGray
        $0.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        layout()
        attribute()
    }
}

// MARK : - Button Action
private extension SetUpProfileViewController {
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func didTapNextButton() {
        let nextVC = CompleteSignUpViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

private extension SetUpProfileViewController {
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
         nextButton].forEach {
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
        
    }
}
