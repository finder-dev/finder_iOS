//
//  SettingViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/16.
//

import UIKit
import SnapKit
import RxSwift

final class SettingViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: SettingViewModel?
    let userNetwork = UserInfoAPI()
    
    // MARK: - Views
    
    let accountLabel = FinderLabel(text: "계정",
                                   font: .systemFont(ofSize: 16.0, weight: .bold),
                                   textColor: .black1)

    let editAccountButton1 = UIButton()
    let editAccountButton2 = UIButton()
    let serviceTermLabel = FinderLabel(text: "이용약관",
                                       font: .systemFont(ofSize: 16.0, weight: .bold),
                                       textColor: .black1)
    let serviceTermButton = UIButton()
    let lineView1 = BarView(barHeight: 1.0, barColor: .grey11)
    let lineView2 = BarView(barHeight: 1.0, barColor: .grey11)
    let deleteAccountButton = UIButton()
    let appVersionLabel = FinderLabel(text: "",
                                      font: .systemFont(ofSize: 14.0, weight: .regular),
                                      textColor: .grey13)
    
    // MARK: - Life Cycle
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func addView() {
        [accountLabel, editAccountButton1, editAccountButton2, serviceTermLabel,
         serviceTermButton, deleteAccountButton, appVersionLabel, lineView1, lineView2].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        accountLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top).offset(16.0)
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
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "설정"
        
        [serviceTermButton,deleteAccountButton,editAccountButton1].forEach {
            $0.setTitleColor(.grey13, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        }
        
        serviceTermButton.setTitle("서비스 이용약관", for: .normal)
        editAccountButton1.setTitle("개인정보 수정", for: .normal)
        editAccountButton2.setImage(UIImage(named: "next"), for: .normal)
        deleteAccountButton.setTitle("탈퇴하기", for: .normal)

        if let info: [String: Any] = Bundle.main.infoDictionary,
             let currentVersion: String
               = info["CFBundleShortVersionString"] as? String {
            appVersionLabel.text = " •  앱 버전 \(currentVersion)"
         }
    }
    
    override func bindViewModel() {
        [editAccountButton1, editAccountButton2].forEach({
            $0.rx.tap
                .subscribe(onNext: { [weak self] in
                    let nextVC = EditUserInfoViewController(viewModel: EditUserInfoViewModel())
                    nextVC.modalPresentationStyle = .overFullScreen
                    self?.present(nextVC, animated: true)
                })
                .disposed(by: disposeBag)
        })
        
        serviceTermButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let nextVC = WebViewController()
                nextVC.modalPresentationStyle = .overFullScreen
                self?.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        deleteAccountButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPopUp2(title: "정말로 탈퇴하시겠습니까?",
                                 message: "탈퇴 후 계정 복구는 불가합니다.",
                                 leftButtonText: "아니오", rightButtonText: "탈퇴",
                                 leftButtonAction: { }, rightButtonAction: {
                    self?.viewModel?.input.deleteAccountTrigger.onNext(())
                })
                
            })
            .disposed(by: disposeBag)
    }
}

// TODO: 추후 수정할 네트워크 로직
private extension SettingViewController {
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
}
