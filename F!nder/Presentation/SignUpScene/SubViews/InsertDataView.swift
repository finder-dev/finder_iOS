//
//  InsertDataView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/12.
//

import UIKit
import SnapKit

final class InsertDataView: UIView {

    let titleLabel = FinderLabel(text: "",
                                 font: .systemFont(ofSize: 16.0, weight: .bold))
    let textField = FinderTextField(placeHolder: "")
    let requestButton = FinderButton(buttonText: "",
                                     buttonTitleFont: .systemFont(ofSize: 14.0, weight: .medium))
    let subTitleLabel = FinderLabel(text: "영문, 숫자 포함 8~ 16자",
                                    font: .systemFont(ofSize: 12.0, weight: .regular),
                                    textColor: .grey6)
    let stackView = UIStackView()
    let insertStackView = UIStackView()
    
    public init(dataType: SignupInsertDataType) {
        super.init(frame: .zero)
        
        titleLabel.text = dataType.rawValue
        textField.placeholder = dataType.placeHolder
        requestButton.setTitle(dataType.buttonTitle, for: .normal)
        
        changeView(by: dataType)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addView() {
        self.addSubview(stackView)
        
        [titleLabel, insertStackView, subTitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [textField, requestButton].forEach {
            insertStackView.addArrangedSubview($0)
        }
    }
    
    func setLayout() {
        
        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        requestButton.snp.makeConstraints {
            $0.width.equalTo(71.0)
        }
    }
    
    func setupView() {
        stackView.axis = .vertical
        stackView.spacing = 8.0
        
        insertStackView.axis = .horizontal
        insertStackView.spacing = 12.0
        
        requestButton.changesSelectionAsPrimaryAction = true
        requestButton.isSelected = false
//        requestButton.isEnabled = false
    }
    
    func changeView(by type: SignupInsertDataType) {
        titleLabel.isHidden = type.rawValue == "" ? true : false
        requestButton.isHidden = type.buttonTitle == "" ? true : false
        subTitleLabel.isHidden = type == .password ? false : true
        
        switch type {
        case .id:
            textField.keyboardType = .emailAddress
        case .code:
            textField.keyboardType = .numberPad
        case .password:
            textField.isSecureTextEntry = true
        case .passwordCheck:
            textField.isSecureTextEntry = true
        case .mbti:
            textField.isUserInteractionEnabled = false
            let button = UIButton()
            button.setImage(UIImage(named: "btn_caretleft_gray"), for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 24.0, height: 24.0)
            
            textField.rightView = button
            textField.rightViewMode = .always
        case .nickname:
            break
        }
    }
}

