//
//  HomeHeaderView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import UIKit
import SnapKit

final class HomeHeaderView: UIView {
    let mainLogoImageView = UIImageView()
    let alarmButton = UIButton()
    let messageButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HomeHeaderView {
    func addView() {
        [mainLogoImageView, alarmButton, messageButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setupView() {
        mainLogoImageView.image = UIImage(named: "main_logo")
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        alarmButton.setImage(UIImage(named: "ic_notification"), for: .normal)
    }
    
    func setupLayout() {
        mainLogoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.bottom.equalToSuperview().inset(10)
        }
        
        alarmButton.snp.makeConstraints {
            $0.centerY.equalTo(mainLogoImageView)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(24.0)
        }

        messageButton.snp.makeConstraints {
            $0.centerY.equalTo(mainLogoImageView)
            $0.trailing.equalTo(alarmButton.snp.leading).offset(-12.0)
            $0.width.height.equalTo(24.0)
        }
    }
}
