//
//  EditUserInfoViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import UIKit

class EditUserInfoViewController: UIViewController {
    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
        setupHeaderView()
    }
}

private extension EditUserInfoViewController {
    func layout() {
        [headerView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
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
