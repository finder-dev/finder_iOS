//
//  EditUserInfoViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import UIKit
import SnapKit

class EditUserInfoViewController: UIViewController {
    let headerView = UIView()
    let nickNameLabel = UILabel()
    let nickNameTextField = UITextField()
    let nickNameCheckButton = UIButton()
    let idLabel = UILabel()
    let idField = UITextField()
    let idCheckButton = UIButton()
    let mbtiLabel = UILabel()
    
    let nextButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        setupHeaderView()
    }
}

private extension EditUserInfoViewController {
    func layout() {
        [headerView,
         nickNameLabel,
         nickNameTextField,
         nickNameCheckButton,
         idLabel,
         idField,
         idCheckButton,
         mbtiLabel,
         nextButton].forEach {
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
        
        idLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameCheckButton.snp.bottom).offset(16.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        idField.snp.makeConstraints {
            $0.leading.equalTo(nickNameLabel)
            $0.top.equalTo(idLabel.snp.bottom).offset(8.0)
        }
        
        idCheckButton.snp.makeConstraints {
            $0.top.equalTo(idField)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.leading.equalTo(idField.snp.trailing).offset(12.0)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.top.equalTo(idField.snp.bottom).offset(16.0)
            $0.leading.equalTo(nickNameLabel)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(26.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(54.0)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
        [nickNameLabel,idLabel,mbtiLabel].forEach {
            $0.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.textColor = .blackTextColor
        }
        
        nickNameLabel.text = "닉네임"
        idLabel.text = "아이디(이메일)"
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

        [nickNameTextField,idField].forEach {
            $0.addLeftPadding(padding: 20.0)
            $0.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
            $0.layer.borderColor = UIColor.textFieldBorder.cgColor
            $0.layer.borderWidth = 1.0
        }
        
        nickNameTextField.placeholder = "6자 이내로 적어주세요"
        idField.placeholder = "이메일을 인증해주세요"
        
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
