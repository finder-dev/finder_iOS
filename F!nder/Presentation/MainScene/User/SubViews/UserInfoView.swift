//
//  UserInfoView.swift
//  F!nder
//
//  Created by 장선영 on 2023/04/02.
//

import UIKit
import SnapKit

final class UserInfoView: UIView {
    let userNameLabel = FinderLabel(text: UserDefaultsData.userNickName,
                                    font: .systemFont(ofSize: 16.0, weight: .bold),
                                    textColor: .black1.withAlphaComponent(0.5))
    let userEmailLabel = FinderLabel(text: UserDefaultsData.userEmail,
                                    font: .systemFont(ofSize: 14.0, weight: .regular),
                                    textColor: .grey13)
    let logOutButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserInfoView {
    
    func addView() {
        [userNameLabel, userEmailLabel, logOutButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setupView() {
        self.backgroundColor = .grey11.withAlphaComponent(0.5)
        self.layer.cornerRadius = 5
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.setTitle("로그아웃", for: .normal)
        logOutButton.backgroundColor = .grey13
        logOutButton.layer.cornerRadius = 5.0
        logOutButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
    }
    
    func setLayout() {
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.leading.equalToSuperview().inset(20)
        }
        
        userEmailLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(userNameLabel)
            $0.bottom.equalToSuperview().inset(27)
        }
        
        logOutButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.top.equalToSuperview().inset(35)
            $0.width.equalTo(64)
            $0.height.equalTo(32)
        }
    }
}
