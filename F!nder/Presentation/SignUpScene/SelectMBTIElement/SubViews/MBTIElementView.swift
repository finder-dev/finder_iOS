//
//  MBTIElementView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/12.
//

import UIKit
import SnapKit
import RxSwift

final class MBTIElementView: UIView {
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let buttonStackView = UIStackView()
    
    var selectedButtonTitle = PublishSubject<String>()
    
    private var leftButtonIsSelected = false {
        didSet {
            if leftButtonIsSelected {
                selectedButtonState(button: leftButton)
            } else {
                deselectedButtonState(button: leftButton)
            }
        }
    }
    
    private var rightButtonIsSelected = false {
        didSet {
            if rightButtonIsSelected {
                selectedButtonState(button: rightButton)
            } else {
                deselectedButtonState(button: rightButton)
            }
        }
    }
  
    public init(leftButtonTitle: String, rightButtonTitle: String) {
        super.init(frame: .zero)
        self.leftButton.setTitle(leftButtonTitle, for: .normal)
        self.rightButton.setTitle(rightButtonTitle, for: .normal)
        
        addView()
        setupLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MBTIElementView {
    func addView() {
        self.addSubview(buttonStackView)
        
        [leftButton, rightButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    func setupLayout() {
        buttonStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(54.0)
        }
    }
    
    func setupView() {
        [leftButton, rightButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .regular)
            $0.setTitleColor(.black1, for: .normal)
            $0.layer.borderColor = UIColor.grey1.cgColor
            $0.layer.borderWidth = 1.0
        }
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = -1
        buttonStackView.distribution = .fillEqually
        
        leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
    }
    
    @objc func tapLeftButton() {
        if !leftButtonIsSelected && !rightButtonIsSelected {
            leftButtonIsSelected = true
        } else {
            leftButtonIsSelected = true
            rightButtonIsSelected = false
        }
    }
    
    @objc func tapRightButton() {
        if !rightButtonIsSelected && !leftButtonIsSelected {
            rightButtonIsSelected = true
        } else {
            rightButtonIsSelected = true
            leftButtonIsSelected = false
        }
    }
    
    func selectedButtonState(button: UIButton) {
        if let buttonTitle = button.title(for: .normal) {
            let title = buttonTitle.split(separator: " ").map { String($0) }
            self.selectedButtonTitle.onNext(title[0])
        }
        
        button.backgroundColor = .primary
        button.setTitleColor(.white, for: .normal)
    }
    
    func deselectedButtonState(button: UIButton) {
        button.backgroundColor = .white
        button.setTitleColor(.black1, for: .normal)
    }
}
