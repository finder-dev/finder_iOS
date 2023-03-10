//
//  SettingViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/16.
//

import UIKit
import SnapKit

class SettingViewController: UIViewController, AlertMessage2Delegate {
    
   
    func leftButtonTapped(from: String) {
        
    }
    
    func rightButtonTapped(from: String) {
        print("탈퇴")
        if from == "deleteAccount" {
            userNetwork.requestDeleteUser { [self] result in
                switch result {
                case let .success(response) :
                    if response.success {
                        print("성공 : 탈퇴")
                        DispatchQueue.main.async {
//                            self.presentCutomAlert1VC(target: "didLogout", title: "로그아웃 되었습니다.", message: "")

                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        print("실패 : 탈퇴")
                        print(response.errorResponse?.errorMessages)
                    }
                case .failure(_):
                    print("오류")
                }
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    let headerView = UIView()
    let accountLabel = UILabel()
    let editAccountButton1 = UIButton()
    let editAccountButton2 = UIButton()
    let lineView1 = UIView()
    
    let serviceTermLabel = UILabel()
    let serviceTermButton = UIButton()
    let lineView2 = UIView()
    
    let deleteAccountButton = UIButton()
    let appVersionLabel = UILabel()
    let userNetwork = UserInfoAPI()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        setupHeaderView()
        attribute()
        
//        [editAccountButton1,editAccountButton2].forEach {
//            $0.isHidden = true
//        }
    }
}

private extension SettingViewController {
    func layout() {
        [headerView,
         accountLabel,
         editAccountButton1,
         editAccountButton2,
         serviceTermLabel,
         serviceTermButton,
         deleteAccountButton,
         appVersionLabel,
         lineView1,
         lineView2].forEach {
            self.view.addSubview($0)
        }
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        editAccountButton1.snp.makeConstraints {
            $0.top.equalTo(accountLabel.snp.bottom).offset(18.0)
            $0.leading.equalTo(accountLabel)
        }
        
        editAccountButton2.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.centerY.equalTo(editAccountButton1)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        lineView1.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(editAccountButton2.snp.bottom).offset(16.0)
        }
        
        serviceTermLabel.snp.makeConstraints {
            $0.leading.equalTo(accountLabel)
            $0.top.equalTo(lineView1.snp.bottom).offset(16.0)
        }
        
        serviceTermButton.snp.makeConstraints {
            $0.top.equalTo(serviceTermLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(accountLabel)
        }
        
        lineView2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(serviceTermButton.snp.bottom).offset(16.0)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp.bottom).offset(16.0)
            $0.leading.equalTo(accountLabel)
        }
        
        appVersionLabel.snp.makeConstraints {
            $0.leading.equalTo(accountLabel)
            $0.top.equalTo(deleteAccountButton.snp.bottom).offset(24.0)
        }

    }
    
    func attribute() {
        self.view.backgroundColor = .white
        
        [accountLabel,serviceTermLabel].forEach {
            $0.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.textColor = .blackTextColor
        }
        
        accountLabel.text = "계정"
        serviceTermLabel.text = "이용약관"

        
        [serviceTermButton,deleteAccountButton,editAccountButton1].forEach {
            $0.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0), for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        }
        
        serviceTermButton.setTitle("서비스 이용약관", for: .normal)
        serviceTermButton.addTarget(self, action: #selector(didTapServiceTermButton), for: .touchUpInside)
        editAccountButton1.setTitle("개인정보 수정", for: .normal)
        editAccountButton2.setImage(UIImage(named: "next"), for: .normal)
        deleteAccountButton.setTitle("탈퇴하기", for: .normal)
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccountButton), for: .touchUpInside)
        
        [editAccountButton1,editAccountButton2].forEach {
            $0.addTarget(self, action: #selector(didTapEditAccountButton), for: .touchUpInside)
        }
        
        [lineView1,lineView2].forEach {
            $0.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
            $0.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        }
        
        appVersionLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        appVersionLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        
//        let version = Bundle.main.
        
        var version = ""
        if let info: [String: Any] = Bundle.main.infoDictionary,
             let currentVersion: String
               = info["CFBundleShortVersionString"] as? String {
            version = currentVersion
         }
    
        appVersionLabel.text = " •  앱 버전 \(version)"
    }
    
    @objc func didTapEditAccountButton() {
        print("didTapEditAccountButton")
        let nextVC = EditUserInfoViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapServiceTermButton() {
        print("didTapServiceTermButton")
        let nextVC = WebViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapDeleteAccountButton() {
        print("didTapServiceTermButton")
        presentCutomAlert2VC(target: "deleteAccount",
                             title: "정말로 탈퇴하시겠습니까?",
                             message: "탈퇴 후 계정 복구는 불가합니다.",
                             leftButtonTitle: "아니오",
                             rightButtonTitle: "탈퇴")
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
}

private extension SettingViewController {
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

        headerLabel.text = "설정"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
        
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}
