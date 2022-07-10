//
//  AlertMessageViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/09.
//

import UIKit
import SnapKit

protocol AlertMessageDelegate {
    func okButtonTapped(from:String)
}

class AlertMessageViewController: UIViewController {
    
    let alertView = UIView()
    let titleLabel = UILabel()
    let textLabel = UILabel()
    let okButton = UIButton()
    
    let alertViewWidth :CGFloat = 319.0
    let okButtonHeight :CGFloat = 56.0
    var titleLabelText : String = ""
    var textLabelText : String?
    var target : String = ""
    
    var delegate: AlertMessageDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.4)
        titleLabel.text = titleLabelText
        layout()
        attribute()
        
        guard let textLabelText = textLabelText else {
            textLabel.isHidden = true
            return
        }
        textLabel.text = textLabelText
    }
}

private extension AlertMessageViewController {
    func layout() {
        self.view.addSubview(alertView)
        
        alertView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(alertViewWidth)
        }
        
        [titleLabel,
         textLabel,
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
            $0.bottom.equalTo(okButton.snp.top).offset(-29.0)
            $0.height.equalTo(20.0)
        }
        
        okButton.snp.makeConstraints {
//            $0.top.equalTo(textLabel.snp.bottom).offset(29.0)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(okButtonHeight)
        }
    }
    
    func attribute() {
        alertView.backgroundColor = .white
        
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        titleLabel.textColor = .blackTextColor
        titleLabel.textAlignment = .center
        
        textLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        textLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        
        okButton.setTitle("확인", for: .normal)
        okButton.backgroundColor = .mainTintColor
        okButton.setTitleColor(.white, for: .normal)
        
        okButton.addTarget(self, action: #selector(didTapOKButton), for: .touchUpInside)
    }
    
    @objc func didTapOKButton() {
        self.dismiss(animated: true)
        delegate.okButtonTapped(from: target)
//        self.presentingViewController?.popoverPresentationController
    }
}
