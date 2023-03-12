//
//  Popup1ViewController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import UIKit
import SnapKit

final class Popup1ViewController: UIViewController {
    
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
    private lazy var okButton = UIButton()

    private var titleText: String = ""
    private var messageText: String = ""
    private var buttonText: String = ""
    private let popupViewWidth :CGFloat = 319.0
    private let okButtonHeight :CGFloat = 56.0
    
    public convenience init(title: String,
                     message: String,
                     buttonText: String,
                     buttonAction: (() -> Void)? = nil) {
        self.init()
        
        self.titleText = title
        self.messageText = message
        self.buttonText = buttonText
       
        
        self.okButton.addAction(for: .touchUpInside) { _ in
            self.dismiss(animated: false) {
                buttonAction?()
            }
        }

        /// present 시 fullScreen (화면 덮도록)
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        titleLabel.text = titleText
        messageLabel.text = messageText

        layout()
        attribute()
    }
}

private extension Popup1ViewController {
    func layout() {
        self.view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(popupViewWidth)
        }
        
        [labelStackView, okButton].forEach {
            self.popupView.addSubview($0)
        }
        
        [titleLabel, messageLabel].forEach {
            self.labelStackView.addArrangedSubview($0)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(okButton.snp.top).inset(-29)
        }
        
        okButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(okButtonHeight)
        }
    }
    
    func attribute() {
        popupView.backgroundColor = .white
        labelStackView.axis = .vertical
        labelStackView.spacing = 8
        
        okButton.setTitle("확인", for: .normal)
        okButton.backgroundColor = .primary
        okButton.setTitleColor(.white, for: .normal)
    }
}
