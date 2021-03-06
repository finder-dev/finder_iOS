//
//  UserViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit

class UserViewController: UIViewController, AlertMessage2Delegate, AlertMessageDelegate {
    func okButtonTapped(from: String) {
        if from == "didLogout" {
            self.navigationController?.popViewController(animated: true)
//            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func leftButtonTapped(from: String) {
    }
    
    func rightButtonTapped(from: String) {
        print("rightButtonTapped")
        print(from)
        if from == "logout" {
//            self.navigationController?.popToRootViewController(animated: true)
            signUpNetwork.requestLogout { result in
                switch result {
                case let .success(response) :
                    if response.success {
                        print("성공 : 로그아웃")
                        DispatchQueue.main.async {
//                            self.presentCutomAlert1VC(target: "didLogout", title: "로그아웃 되었습니다.", message: "")

                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        print("실패 : 로그아웃")
                        print(response.errorResponse?.errorMessages)
                    }
                case .failure(_):
                    print("오류")
                }
            }
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    let headerView = UIView()
    let userInfoView = UIView()
    let userNameLabel = UILabel()
    let userEmailLabel = UILabel()
    let logOutButton = UIButton()
    
    let signUpNetwork = SignUpAPI()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()
        setupHeaderView()
    }
    
    func addData() {
        let userNickName = UserDefaults.standard.string(forKey: "userNickName")
        let userEmail = UserDefaults.standard.string(forKey: "userEmail")
        userNameLabel.text = userNickName
        userEmailLabel.text = userEmail
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
        signUpNetwork.requestLogout { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 로그아웃")
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    print("실패 : 로그아웃")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
//        presentCutomAlert2VC(target: "logout",
//                             title: "로그아웃하시겠습니까?",
//                             message: "",
//                             leftButtonTitle: "아니오",
//                             rightButtonTitle: "로그아웃")
    }
    
    func presentCutomAlert2VC(target:String,
                              title:String,
                              message:String,
                              leftButtonTitle:String,
                              rightButtonTitle:String) {
        
        let nextVC = AlertMessage2ViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.leftButtonTitle = leftButtonTitle
        nextVC.rightButtonTitle = rightButtonTitle
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    func presentCutomAlert1VC(target:String,
                              title:String,
                              message:String) {
        let nextVC = AlertMessageViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
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
