//
//  UserViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit

class UserViewController: UIViewController {
    
    let headerView = UIView()
    let userInfoView = UIView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    let logOutButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()
        setupHeaderView()
        
        addData()
    }
    
    func addData() {
        userNameLabel.text = "test"
        userEmailLabel.text = "test"
    }
}

private extension UserViewController {
    func layout() {
        [headerView,userInfoView].forEach {
            self.view.addSubview($0)
        }
        
        userInfoView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(headerView.snp.bottom).offset(20.0)
            $0.height.equalTo(101.0)
        }
        
        setupUserView()
    }
    
    func attribute() {
        userInfoView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.5)
    }
    
    func setupHeaderView() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }

        let headerLabel = UILabel()
        let setupButton = UIButton()
        
        [headerLabel,setupButton].forEach {
            headerView.addSubview($0)
        }
        
        headerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        setupButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
        }

        headerLabel.text = "마이"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
        
        setupButton.setImage(UIImage(named: "clarity_settings"), for: .normal)
        setupButton.addTarget(self, action: #selector(didTapSetupButton), for: .touchUpInside)
    }
    
    @objc func didTapSetupButton() {
        print("didTapSetupButton")
        let nextVC = SettingViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapLogutButton() {
        print("didTapLogutButton")
        self.navigationController?.popToRootViewController(animated: true)
        
    }
}

private extension UserViewController {
    func setupUserView() {
        [userNameLabel,userEmailLabel,logOutButton].forEach {
            self.userInfoView.addSubview($0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(27.0)
        }
        
        userEmailLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4.0)
        }
        
        logOutButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(32.0)
            $0.width.equalTo(64.0)
        }
        
        logOutButton.setTitleColor(.white, for: .normal)
        logOutButton.setTitle("로그아웃", for: .normal)
        logOutButton.backgroundColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        logOutButton.layer.cornerRadius = 5.0
        logOutButton.addTarget(self, action: #selector(didTapLogutButton), for: .touchUpInside)
        logOutButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        
        userNameLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        userNameLabel.textColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0)
        
        userEmailLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        userEmailLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    }
}
