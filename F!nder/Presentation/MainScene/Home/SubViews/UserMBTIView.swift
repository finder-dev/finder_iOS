//
//  UserMBTIView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import UIKit
import SnapKit

final class UserMBTIView: UIView {
    
    let userMBTILabel = FinderLabel(text: "INFJ",
                                    font: .systemFont(ofSize: 20.0, weight: .bold),
                                    textColor: .black1)
    let userNameLabel = FinderLabel(text: "\(UserDefaultsData.userNickName)님,",
                                    font: .systemFont(ofSize: 20.0, weight: .bold),
                                    textColor: .black1)
    let emptyLabel = UILabel()
    let mbtiMessageLabel = FinderLabel(text: "",
                                       font: .systemFont(ofSize: 16.0, weight: .medium),
                                       textColor: .textGrayColor)
    let mbtiImageView = UIImageView()
    let userLabelStackView = UIStackView()
    let labelStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension UserMBTIView {
    func addView() {
        [labelStackView, mbtiMessageLabel, mbtiImageView].forEach {
            self.addSubview($0)
        }
        
        [userMBTILabel, userNameLabel, emptyLabel].forEach {
            self.userLabelStackView.addArrangedSubview($0)
        }
        
        [userLabelStackView, mbtiMessageLabel].forEach {
            self.labelStackView.addArrangedSubview($0)
        }
    }
    
    func setLayout() {
        
        mbtiImageView.snp.makeConstraints {
            $0.width.equalTo(155.0)
            $0.height.equalTo(140.0)
            $0.trailing.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(mbtiImageView.snp.leading).offset(-50)
        }
    }
    
    func setupView() {
        userLabelStackView.axis = .horizontal
        userLabelStackView.spacing = 5
        
        userNameLabel.setFont(targetString: "님,", font: .systemFont(ofSize: 16.0, weight: .regular))
        userNameLabel.numberOfLines = 1
    
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        
        mbtiMessageLabel.setLineHeight(lineHeight: CGFloat(25.0))
        mbtiImageView.contentMode = .scaleAspectFit
        mbtiImageView.clipsToBounds = false
        setUpData()
    }
    
    func setUpData() {
        let data = MBTI.getMBTI(UserDefaultsData.userMBTI)
        userMBTILabel.text = data.rawValue
        mbtiMessageLabel.text = data.mbtiMessage
        mbtiImageView.image = data.mbtiImage
    }
}
