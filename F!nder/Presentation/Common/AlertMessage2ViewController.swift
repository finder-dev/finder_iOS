//
//  AlertMessage2ViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/21.
//


import UIKit
import SnapKit

protocol AlertMessage2Delegate {
    func leftButtonTapped(from:String)
    func rightButtonTapped(from:String)
}

class AlertMessage2ViewController: UIViewController {
    
    let alertView = UIView()
    let titleLabel = UILabel()
    let textLabel = UILabel()
    let noButton = UIButton()
    let okButton = UIButton()
    
    let alertViewWidth :CGFloat = 319.0
    let okButtonHeight :CGFloat = 56.0
    var titleLabelText : String = ""
    var textLabelText : String?
    var target : String = ""
    var rightButtonTitle: String = ""
    var leftButtonTitle: String = ""
    
    var delegate: AlertMessage2Delegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        titleLabel.text = titleLabelText
        layout()
        attribute()
        okButton.setTitle(rightButtonTitle, for: .normal)
        noButton.setTitle(leftButtonTitle, for: .normal)
        
        guard let textLabelText = textLabelText else {
            textLabel.isHidden = true
            return
        }
        textLabel.text = textLabelText
    }
}

private extension AlertMessage2ViewController {
    func layout() {
        self.view.addSubview(alertView)
        
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(alertViewWidth)
        }
        
        [titleLabel,
         textLabel,
         noButton,
         okButton].forEach {
            self.alertView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(25.0)
            $0.height.equalTo(26.0)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(okButton.snp.top).offset(-29.0)
        }
        
        okButton.snp.makeConstraints {
//            $0.top.equalTo(textLabel.snp.bottom).offset(29.0)
            $0.trailing.bottom.equalToSuperview()
            $0.height.equalTo(okButtonHeight)
            $0.width.equalTo(alertViewWidth/2)
            $0.leading.equalTo(noButton.snp.trailing)
        }
        noButton.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(okButtonHeight)
            $0.width.equalTo(alertViewWidth/2)
        }
    }
    
    func attribute() {
        alertView.backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        titleLabel.textColor = .black1
        titleLabel.textAlignment = .center
        
        textLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        textLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        okButton.setTitle("확인", for: .normal)
        okButton.backgroundColor = .primary
        okButton.setTitleColor(.white, for: .normal)
        
        okButton.addTarget(self, action: #selector(didTapOKButton), for: .touchUpInside)
        noButton.setTitle("아니요", for: .normal)
        noButton.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        noButton.setTitleColor(UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0), for: .normal)
        noButton.addTarget(self, action: #selector(didTapNoButton), for: .touchUpInside)
        
        [noButton,okButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        }
    }
    
    @objc func didTapOKButton() {
        self.dismiss(animated: true)
        delegate.rightButtonTapped(from: target)
    }

    @objc func didTapNoButton() {
        self.dismiss(animated: true)
        delegate.leftButtonTapped(from: target)
    }
}
