//
//  CompleteSignUpViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/22.
//

import UIKit
import SnapKit
import Then

class CompleteSignUpViewController: UIViewController {
    
    private lazy var completeSignUpImageView = UIImageView().then {
        $0.image = UIImage(named: "sign up_finish_img")
    }
    
    private lazy var completeSignUpLabel = UILabel().then {
        $0.text = "회원가입을 축하드려요!"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20.0, weight: .medium)
    }
    
    private lazy var completeSignUpButton = UIButton().then {
        $0.setTitle("회원가입 완료", for: .normal)
        $0.backgroundColor = .mainTintColor
        $0.setTitleColor(.white, for: .normal)
        $0.addTarget(self, action: #selector(didTapCompleteSignUpButton),for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()

        // Do any additional setup after loading the view.
    }
    
    @objc func didTapCompleteSignUpButton() {
        
    }

}

private extension CompleteSignUpViewController {
    func layout() {
        [completeSignUpImageView,completeSignUpLabel,completeSignUpButton].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        completeSignUpImageView.snp.makeConstraints {
            $0.width.equalTo(343.0)
            $0.height.equalTo(336.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(207.0)
        }
        
        completeSignUpLabel.snp.makeConstraints {
            $0.top.equalTo(completeSignUpImageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        completeSignUpButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea.snp.bottom).inset(26.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(54.0)
        }
    }
}
