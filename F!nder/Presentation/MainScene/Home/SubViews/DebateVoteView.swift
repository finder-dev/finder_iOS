//
//  DebateVoteView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import UIKit
import SnapKit

enum DebateVoteViewAt {
    case home
    case detail
}

final class DebateVoteView: UIView {

    let debateTitleLabel = FinderLabel(text: "친구의 깻잎, 10 장이 엉겨붙었는데 \n애인이 떼줘도 된다 애인이 떼줘도 된다?",
                                       font: .systemFont(ofSize: 16.0, weight: .medium),
                                       textColor: .black1,
                                       textAlignment: .center)
    
    let debateTimeLabel = FinderLabel(text: "남은 시간 D-3",
                                      font: .systemFont(ofSize: 12.0, weight: .regular),
                                      textColor: UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0),
                                      textAlignment: .center)
    var buttonA = UIButton()
    let buttonACountLabel = FinderLabel(text: "0",
                                        font: .systemFont(ofSize: 44.0, weight: .bold),
                                        textColor: .grey3, textAlignment: .center)
    
    var buttonB = UIButton()
    var buttonStackView = UIStackView()
    let buttonBCountLabel = FinderLabel(text: "0",
                                        font: .systemFont(ofSize: 44.0, weight: .bold),
                                        textColor: .grey3, textAlignment: .center)
    var buttonAImageView = UIImageView()
    var buttonBImageView = UIImageView()
    let userMBTILabel = FinderLabel(text: "ENTJ",
                                    font: .systemFont(ofSize: 12.0, weight: .regular),
                                    textColor: .grey6)
    let dotLabel = FinderLabel(text: "•",
                               font: .systemFont(ofSize: 12.0, weight: .regular),
                               textColor: .grey6)
    let userNameLabel = FinderLabel(text: "수완완",
                                    font: .systemFont(ofSize: 12.0, weight: .regular),
                                    textColor: .grey6)
    let commentCountLabel = FinderLabel(text: "댓글 3",
                                        font: .systemFont(ofSize: 12.0, weight: .regular),
                                        textColor: .grey6)
    var agreeButtonConstraints: NSLayoutConstraint!
    var disAgreeButtonConstraints: NSLayoutConstraint!
    
    public init(at: DebateVoteViewAt) {
        switch at {
        case .home:
            [userMBTILabel, userNameLabel, commentCountLabel, dotLabel].forEach {
                $0.isHidden = true
            }
        case .detail:
            [userMBTILabel, userNameLabel, commentCountLabel, dotLabel].forEach {
                $0.isHidden = false
            }
        }
        
        super.init(frame: .zero)
        addSubview()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ data: HotDebateSuccessResponse) {
        debateTitleLabel.text = data.title
        debateTimeLabel.text = data.deadline
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
        [debateTitleLabel,debateTimeLabel, buttonACountLabel, buttonBCountLabel,
         buttonA, buttonB, buttonAImageView, buttonBImageView, buttonStackView,
         userMBTILabel, dotLabel, userNameLabel, commentCountLabel].forEach {
            self.addSubview($0)
        }
        
        [buttonA, buttonB].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
    }
    
    func setLayout() {
        debateTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(self.snp.top)
        }
        
        debateTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(debateTitleLabel.snp.bottom).offset(6.0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(debateTitleLabel.snp.bottom).offset(75.0)
            $0.height.equalTo(55.0)
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
        
        userMBTILabel.snp.makeConstraints {
            $0.top.equalTo(buttonStackView.snp.bottom).offset(37.0)
            $0.leading.equalTo(buttonStackView)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        dotLabel.snp.makeConstraints {
            $0.centerY.equalTo(userMBTILabel)
            $0.leading.equalTo(userMBTILabel.snp.trailing).offset(8.0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userMBTILabel)
            $0.leading.equalTo(dotLabel.snp.trailing).offset(8.0)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(userNameLabel)
            $0.trailing.equalTo(buttonStackView)
        }
        
        agreeButtonConstraints = self.buttonACountLabel.topAnchor.constraint(equalTo: debateTimeLabel.bottomAnchor,
                                                                             constant: 22.0)
        disAgreeButtonConstraints = self.buttonBCountLabel.topAnchor.constraint(equalTo: debateTimeLabel.bottomAnchor,
                                                                                constant: 22.0)
        agreeButtonConstraints.isActive = true
        disAgreeButtonConstraints.isActive = true
    }
    
    func setupView() {
        debateTitleLabel.setLineHeight(lineHeight: 24.0)
        
        buttonA.setTitle("test", for: .normal)
        buttonB.setTitle("test", for: .normal)
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually
        
        [buttonA,buttonB].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.setTitleColor(.grey3, for: .normal)
            $0.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
            $0.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        }
        
        buttonA.contentHorizontalAlignment = .left
        buttonB.contentHorizontalAlignment = .right
        
        buttonA.titleEdgeInsets.left = 20.0
        buttonB.titleEdgeInsets.right = 20.0
                
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

        agreeButtonConstraints.constant = 11.0
        disAgreeButtonConstraints.constant = 22.0

        buttonAImageView.isHidden = false
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        buttonA.backgroundColor = selectedColor
        buttonA.setTitleColor(.white, for: .normal)
        buttonACountLabel.textColor = selectedColor
        
        buttonBImageView.isHidden = true
        buttonB.backgroundColor = .grey7
        buttonB.setTitleColor(.grey8, for: .normal)
        buttonBCountLabel.textColor = .grey8
    }
    
    func selectB() {
        
        agreeButtonConstraints.constant = 22.0
        disAgreeButtonConstraints.constant = 11.0

        buttonBImageView.isHidden = false
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        buttonB.backgroundColor = selectedColor
        buttonB.setTitleColor(.white, for: .normal)
        buttonBCountLabel.textColor = selectedColor
        
        buttonAImageView.isHidden = true
        buttonA.backgroundColor = .grey7
        buttonA.setTitleColor(.grey8, for: .normal)
        buttonACountLabel.textColor = .grey8
    }
}
