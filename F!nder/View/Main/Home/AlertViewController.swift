//
//  AlertViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/06.
//

import UIKit
import SnapKit

enum AlertStatus {
    case noAlert
    case yesAlert
}

class AlertViewController: UIViewController {
    
    var alertStatus: AlertStatus = .noAlert
    
    // Header 설정
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private lazy var headerTitle = UILabel().then {
        $0.text = "소식"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textAlignment = .center
    }
    
    var noAlertView = UIView()
    var yesAlertView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        if alertStatus == .noAlert {
//            noAlertView.isHidden = false
//            yesAlertView.isHidden = true
//        } else {
//            noAlertView.isHidden = true
//            yesAlertView.isHidden = false
//        }
        
        layout()
        attribute()
    }
}

private extension AlertViewController {
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension AlertViewController {
    func layout() {
        [backButton,
         headerTitle].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        backButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(safeArea.snp.top).inset(12.0)
        }
        
        headerTitle.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        if alertStatus == .noAlert {
            noAlertViewLayout()
        } else {
            yesAlertViewLayout()
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
    }
}

// 알림이 없는 경우 view
private extension AlertViewController {
    func noAlertViewLayout() {
        
        self.view.addSubview(noAlertView)
        
        noAlertView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerTitle.snp.bottom).offset(14.0)
        }
        
        let noAlertImageView = UIImageView()
        noAlertImageView.image = UIImage(named: "Group 986335")
        
        noAlertView.addSubview(noAlertImageView)
        
        noAlertImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(120.0)
        }
    }
}

// 알림이 있는 경우 view
private extension AlertViewController {
    func yesAlertViewLayout() {
        
    }
}
