//
//  SignUpProcessView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import UIKit
import SnapKit

enum SignUpProcess {
    case insertData
    case settingProfile
    case completeSignUp
}

final class SignUpProcessView: UIView {
    
    let insertImageView = UIImageView(image: UIImage(named: "signin_step1_orange"))
    let insertLabel = FinderLabel(text: " 정보 입력",
                                  font: .systemFont(ofSize: 14.0, weight: .medium),
                                  textColor: .mainTintColor,
                                  textAlignment: .center)
    
    let settingImageView = UIImageView(image: UIImage(named: "signin_step2_gray"))
    let settingLabel = FinderLabel(text: "프로필 설정",
                                   font: .systemFont(ofSize: 14.0, weight: .medium),
                                   textColor: .grey5,
                                   textAlignment: .center)
    
    let completeImageView = UIImageView(image: UIImage(named: "signin_step3_gray"))
    let completeLabel = FinderLabel(text: "가입 완료 ",
                                    font: .systemFont(ofSize: 14.0, weight: .medium),
                                    textColor: .grey5,
                                    textAlignment: .center)
    
    let caretView1 = UIView()
    let caretImageView1 = UIImageView(image: UIImage(named: "btn_caretleft_bold"))
    let caretView2 = UIView()
    let caretImageView2 = UIImageView(image: UIImage(named: "btn_caretleft_bold"))
    let imageStackView = UIStackView()
    let labelStackView = UIStackView()
    
    var process: SignUpProcess = .insertData {
        didSet {
            changeView(as: process)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SignUpProcessView {
    func addView() {
        [imageStackView, labelStackView].forEach {
            self.addSubview($0)
        }
        
        [insertImageView, caretView1, settingImageView, caretView2, completeImageView].forEach {
            self.imageStackView.addArrangedSubview($0)
        }
        
        caretView1.addSubview(caretImageView1)
        caretView2.addSubview(caretImageView2)
        
        [insertLabel, settingLabel, completeLabel].forEach {
            self.labelStackView.addArrangedSubview($0)
        }
    }
    
    func setupLayout() {
        
        imageStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.centerX.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(imageStackView.snp.bottom).offset(12.0)
            $0.leading.trailing.equalTo(imageStackView)
            $0.bottom.equalToSuperview()
        }
        
        insertImageView.snp.makeConstraints {
            $0.width.height.equalTo(60.0)
        }
        
        settingImageView.snp.makeConstraints {
            $0.width.height.equalTo(60.0)
        }
        
        completeImageView.snp.makeConstraints {
            $0.width.height.equalTo(60.0)
        }
        
        caretImageView1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18.0)
            $0.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(24.0)
        }
        
        caretImageView2.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18.0)
            $0.leading.trailing.equalToSuperview()
            $0.width.height.equalTo(24.0)
        }
    }
    
    func setupView() {
        imageStackView.axis = .horizontal
        imageStackView.spacing = 12.0
        imageStackView.distribution = .equalSpacing
        
        labelStackView.axis = .horizontal
        labelStackView.distribution = .equalSpacing
    }
    
    func changeView(as process: SignUpProcess) {
        
        switch process {
        case .insertData:
            insertImageView.image = UIImage(named: "signin_step1_orange")
            settingImageView.image = UIImage(named: "signin_step2_gray")
            completeImageView.image = UIImage(named: "signin_step3_gray")
            insertLabel.textColor = .mainTintColor
            settingLabel.textColor = .grey5
            completeLabel.textColor = .grey5
            
        case .settingProfile:
            insertImageView.image = UIImage(named: "signin_step1_gray")
            settingImageView.image = UIImage(named: "signin_step2_orange")
            completeImageView.image = UIImage(named: "signin_step3_gray")
            insertLabel.textColor = .grey5
            settingLabel.textColor = .mainTintColor
            completeLabel.textColor = .grey5
            
        case .completeSignUp:
            insertImageView.image = UIImage(named: "signin_step1_gray")
            settingImageView.image = UIImage(named: "signin_step2_gray")
            completeImageView.image = UIImage(named: "signin_step3_orange")
            insertLabel.textColor = .grey5
            settingLabel.textColor = .grey5
            completeLabel.textColor = .mainTintColor
        }
    }
}
