//
//  LoginViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/16.
//

import Foundation
import UIKit
import SnapKit
import Then

class LoginViewController: UIViewController {
    
    private lazy var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo_f!nder_orange")
    }
    
    private lazy var characterImageView = UIImageView().then {
        $0.image = UIImage(named: "main character")
    }
    
    private lazy var kakaoLoginView = UIView().then {
        $0.backgroundColor = UIColor(red:  254/255, green: 229/255, blue: 0/255, alpha: 1.0)
        $0.addSubview(kakaoLoginLabel)
        $0.addSubview(kakaoLoginImage)
        $0.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapKakaoLogin))
        $0.addGestureRecognizer(gesture)
    }
    
    private lazy var kakaoLoginImage = UIImageView().then {
        $0.image = UIImage(named: "btn_login_kakao")
    }
    
    private lazy var kakaoLoginLabel = UILabel().then {
        $0.text = "카카오로 로그인"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var appleLoginView = UIView().then {
        $0.backgroundColor = .black
        $0.addSubview(appleLoginLabel)
        $0.addSubview(appleLoginImage)
        $0.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapAppleLogin))
        $0.addGestureRecognizer(gesture)
    }

    private lazy var appleLoginImage = UIImageView().then {
        $0.image = UIImage(named: "btn_login_apple")
    }
    
    private lazy var appleLoginLabel = UILabel().then {
        $0.text = "애플로 로그인"
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.textColor = .white
    }
    
    private lazy var emailLoginButton = UIButton(type: .system).then {
        $0.setTitle("이메일로 시작하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.addTarget(self, action: #selector(didTapEmailLogin), for: .touchUpInside)
        $0.setUnderline()
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()
    }
    
    @objc func didTapKakaoLogin() {
        print("didTapKakoLogin")
    }
    
    @objc func didTapEmailLogin() {
        print("didTapEmailLogin")
        let nextVC = EmailLoginViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapAppleLogin() {
        print("didTapAppleLogin")
    }
}

private extension LoginViewController {
    
    func layout() {
        [
            logoImageView,
            characterImageView,
            kakaoLoginView,
            appleLoginView,
            emailLoginButton
        ].forEach {
            self.view.addSubview($0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(181.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(243.0)
            $0.height.equalTo(80.0)
        }
        
        characterImageView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(4.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(239.0)
            $0.height.equalTo(217.0)
        }
        
        emailLoginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(80.0)
            $0.centerX.equalToSuperview()
//            $0.width.equalTo(94.0)
        }
        
        appleLoginView.snp.makeConstraints {
            $0.bottom.equalTo(emailLoginButton.snp.top).inset(-4.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.0)
        }
        
        kakaoLoginView.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginView.snp.top).inset(-12.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.0)
        }
        
        loginViewLayout()
    }
    
    func loginViewLayout() {
        
        kakaoLoginLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        kakaoLoginImage.snp.makeConstraints {
            $0.centerY.equalTo(kakaoLoginView)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        appleLoginLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        appleLoginImage.snp.makeConstraints {
            $0.centerY.equalTo(appleLoginView)
            $0.leading.equalToSuperview().inset(16.0)
        }

    }
    
    func attribute() {
        self.navigationController?.navigationBar.isHidden = true
    }
}
