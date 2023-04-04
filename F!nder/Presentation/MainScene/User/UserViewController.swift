//
//  UserViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift

final class UserViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: UserViewModel?
    let signUpNetwork = SignUpAPI()
    
    // MARK: - Views
    
    private let settingButton = UIBarButtonItem(image: UIImage(named: "clarity_settings"),
                                                style: .plain, target: nil, action: nil)
    private let userInfoView = UserInfoView()
    
    // MARK: - Life Cycle
    
    init(viewModel: UserViewModel) {
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
        [userInfoView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setupView() {
        self.title = "마이"
        self.view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = settingButton
    }
    
    override func setLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        userInfoView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea).inset(20)
        }
    }
    
    override func bindViewModel() {
        settingButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let nextVC = SettingViewController(viewModel: SettingViewModel())
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        userInfoView.logOutButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showPopUp2(title: "로그아웃하시겠습니까?", message: "",
                                 leftButtonText: "아니오", rightButtonText: "로그아웃",
                                 leftButtonAction: {}, rightButtonAction: {
                    self?.viewModel?.input.logoutTrigger.onNext(())
                })
            })
            .disposed(by: disposeBag)
    }
}

// TODO: 추후 수정할 네트워크 관련 로직
private extension UserViewController {
    
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
}
