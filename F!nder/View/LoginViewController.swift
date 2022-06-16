//
//  LoginViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/16.
//

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
    
    private lazy var kakaoLoginButton = UIButton(type: .custom).then {
        $0.setTitle("카카오로 로그인", for: .normal)
        $0.setImage(UIImage(named: "btn_login_kakao"), for: .normal)
        $0.backgroundColor = UIColor(red:  254/255, green: 229/255, blue: 0/255, alpha: 1.0)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
    }
    
    private lazy var appleLoginButton = UIButton(type: .custom).then {
        $0.setTitle("애플로 로그인", for: .normal)
        $0.setImage(UIImage(named: "btn_login_apple"), for: .normal)
        $0.backgroundColor = .black
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
    }
    
    private lazy var emailLoginButton = UIButton(type: .custom).then {
        $0.setTitle("이메일로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()

    }
}

private extension LoginViewController {
    
    func layout() {
        [
            logoImageView,
            characterImageView,
            kakaoLoginButton,
            appleLoginButton,
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
            $0.width.equalTo(94.0)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(emailLoginButton.snp.top).inset(-4.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.0)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.bottom.equalTo(appleLoginButton.snp.top).inset(-12.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(327.0)
        }
    }
    
    func attribute() {
        
    }
}
