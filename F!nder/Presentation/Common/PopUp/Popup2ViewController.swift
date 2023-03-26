//
//  Popup2ViewController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/16.
//

import UIKit
import SnapKit

final class Popup2ViewController: UIViewController {
    
    private let popupView = UIView()
    private lazy var titleLabel = FinderLabel(text: titleText,
                                              font: .systemFont(ofSize: 18.0, weight: .medium),
                                              textColor: .black,
                                              textAlignment: .center)
    private lazy var messageLabel = FinderLabel(text: messageText,
                                                font: .systemFont(ofSize: 14.0, weight: .regular),
                                                textColor: UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0),
                                                textAlignment: .center)
    private let labelStackView = UIStackView()
    
    private lazy var leftButton = UIButton()
    private lazy var rightButton = UIButton()
    private let buttonStackView = UIStackView()
    
    private var titleText: String = ""
    private var messageText: String = ""
    private var leftButtonText: String = ""
    private var rightButtonText: String = ""
    private let popupViewWidth :CGFloat = 319.0
    
    public convenience init(title: String,
                            message: String,
                            leftButtonText: String,
                            rightButtonText: String,
                     leftButtonAction: (() -> Void)? = nil, rightButtonAction: (() -> Void)? = nil) {
        self.init()
        
        self.titleText = title
        self.messageText = message
        self.leftButtonText = leftButtonText
        self.rightButtonText = rightButtonText       
        
        self.leftButton.addAction(for: .touchUpInside) { _ in
            self.dismiss(animated: false) {
                leftButtonAction?()
            }
        }

        self.rightButton.addAction(for: .touchUpInside) { _ in
            self.dismiss(animated: false) {
                rightButtonAction?()
            }
        }
        /// present 시 fullScreen (화면 덮도록)
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        attribute()
    }
}

private extension Popup2ViewController {
    func layout() {
        self.view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(popupViewWidth)
        }
        
        [labelStackView, buttonStackView].forEach {
            self.popupView.addSubview($0)
        }
        
        [titleLabel, messageLabel].forEach {
            self.labelStackView.addArrangedSubview($0)
        }
        
        [leftButton, rightButton].forEach {
            self.buttonStackView.addArrangedSubview($0)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(buttonStackView.snp.top).inset(-29)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(56.0)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        popupView.backgroundColor = .white
        
        titleLabel.text = titleText
        messageLabel.text = messageText
        leftButton.setTitle(leftButtonText, for: .normal)
        rightButton.setTitle(rightButtonText, for: .normal)
        
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        leftButton.backgroundColor = .grey11
        leftButton.setTitleColor(.grey3, for: .normal)
        rightButton.backgroundColor = .primary
        rightButton.setTitleColor(.white, for: .normal)
        
        [leftButton, rightButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        }
    }
}
