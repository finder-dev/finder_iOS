//
//  DebateVoteView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import UIKit
import SnapKit

class DebateVoteView: UIView {

    var balaceGameTitleLabel = UILabel()
    var balanceGameTimeLabel = UILabel()
    var buttonA = UIButton()
    var buttonACountLabel = UILabel()
    var buttonB = UIButton()
    var buttonStackView = UIStackView()
    var buttonBCountLabel = UILabel()
    var buttonAImageView = UIImageView()
    var buttonBImageView = UIImageView()
    var AgreeButtonConstraints: NSLayoutConstraint!
    var disAgreeButtonConstraints: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ data: HotDebateSuccessResponse) {
        balaceGameTitleLabel.text = data.title
        balanceGameTimeLabel.text = data.deadline
        buttonACountLabel.text = "\(data.optionACount)"
        buttonBCountLabel.text = "\(data.optionBCount)"
        buttonA.setTitle(data.optionA, for: .normal)
        buttonB.setTitle(data.optionA, for: .normal)

        if data.join {
            if data.joinOption == "A" {
                selectA()
            } else if data.joinOption == "B" {
                selectB()
            }
        }
    }
}

private extension DebateVoteView {
    
    func addSubview() {
        [balaceGameTitleLabel,balanceGameTimeLabel, buttonACountLabel, buttonBCountLabel,
         buttonA, buttonB, buttonAImageView, buttonBImageView, buttonStackView].forEach {
            self.self.addSubview($0)
        }
        
        [buttonA, buttonB].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
    }
    
    func setLayout() {
        balaceGameTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(self.snp.top)
        }
        
        balanceGameTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(balaceGameTitleLabel.snp.bottom).offset(4.0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(balaceGameTitleLabel.snp.bottom).offset(75.0)
            $0.height.equalTo(55.0)
            $0.bottom.equalToSuperview().inset(36.0)
        }
        
        buttonACountLabel.snp.makeConstraints {
            $0.trailing.equalTo(buttonA).inset(10)
        }

        buttonBCountLabel.snp.makeConstraints {
            $0.leading.equalTo(buttonB).inset(10)
        }
        
        buttonAImageView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top)
            $0.leading.equalTo(buttonStackView)
        }

        buttonBImageView.snp.makeConstraints {
            $0.bottom.equalTo(buttonStackView.snp.top)
            $0.trailing.equalTo(buttonStackView)
        }
        
        AgreeButtonConstraints = self.buttonACountLabel.topAnchor.constraint(equalTo: balanceGameTimeLabel.bottomAnchor, constant: 22.0)
        disAgreeButtonConstraints = self.buttonBCountLabel.topAnchor.constraint(equalTo: balanceGameTimeLabel.bottomAnchor, constant: 22.0)
        AgreeButtonConstraints.isActive = true
        disAgreeButtonConstraints.isActive = true
    }
    
    func setupView() {
        balaceGameTitleLabel.text = "친구의 깻잎, 10 장이 엉겨붙었는데 \n애인이 떼줘도 된다 애인이 떼줘도 된다?"
        balaceGameTitleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        balaceGameTitleLabel.textColor = .blackTextColor
        balaceGameTitleLabel.textAlignment = .center
        balaceGameTitleLabel.numberOfLines = 0
        
        balanceGameTimeLabel.text = "남은 시간 D-3"
        balanceGameTimeLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        balanceGameTimeLabel.textColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        
        [buttonACountLabel,buttonBCountLabel].forEach {
            $0.font = .systemFont(ofSize: 44.0, weight: .bold)
            $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            $0.text = "0"
            $0.textAlignment = .center
        }
        
        buttonA.setTitle("test", for: .normal)
        buttonB.setTitle("test", for: .normal)
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        [buttonA,buttonB].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.setTitleColor(UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0), for: .normal)
            $0.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
            $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        }
        
        buttonA.contentHorizontalAlignment = .left
        buttonB.contentHorizontalAlignment = .right
        
        buttonA.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        buttonB.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
                
        [buttonAImageView,buttonBImageView].forEach {
            $0.image = UIImage(named: "Frame 986295")
            $0.isHidden = true
        }
    }
    
    @objc func tapButton(_ sender: UIButton) {
        if sender == buttonA {
            selectA()
        } else {
            selectB()
        }
    }
    
    func selectA() {

        AgreeButtonConstraints.constant = 11.0
        disAgreeButtonConstraints.constant = 22.0

        buttonAImageView.isHidden = false
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        buttonA.backgroundColor = selectedColor
        buttonA.setTitleColor(.white, for: .normal)
        buttonACountLabel.textColor = selectedColor
        
        buttonBImageView.isHidden = true
        buttonB.backgroundColor = .unabledButtonColor
        buttonB.setTitleColor(.unabledButtonTextColor, for: .normal)
        buttonBCountLabel.textColor = .unabledButtonTextColor
    }
    
    func selectB() {
        
        AgreeButtonConstraints.constant = 22.0
        disAgreeButtonConstraints.constant = 11.0

        buttonBImageView.isHidden = false
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        buttonB.backgroundColor = selectedColor
        buttonB.setTitleColor(.white, for: .normal)
        buttonBCountLabel.textColor = selectedColor
        
        buttonAImageView.isHidden = true
        buttonA.backgroundColor = .unabledButtonColor
        buttonA.setTitleColor(.unabledButtonTextColor, for: .normal)
        buttonACountLabel.textColor = .unabledButtonTextColor
    }
}
