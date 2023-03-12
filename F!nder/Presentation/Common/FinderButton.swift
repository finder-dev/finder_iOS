//
//  FinderButton.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import Foundation
import UIKit

final class FinderButton: UIButton {
    
    /// textColor = black, textAlignment = left로 default 설정
    public init(buttonText: String, buttonTitleFont: UIFont = .systemFont(ofSize: 16.0, weight: .medium), buttonHeight: CGFloat = 54.0) {
                    
        super.init(frame: .zero)
        
        self.setTitle(buttonText, for: .normal)
        self.titleLabel?.font = buttonTitleFont
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .primary
                self.setTitleColor(.white, for: .normal)
            } else {
                self.backgroundColor = .grey7
                self.setTitleColor(.grey8, for: .normal)
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = .grey7
                self.setTitleColor(.grey8, for: .normal)
            } else {
                self.backgroundColor = .primary
                self.setTitleColor(.white, for: .normal)
            }
        }
    }
    
    func attribute() {
        translatesAutoresizingMaskIntoConstraints = false
//        self.backgroundColor = .mainTintColor
//        self.setTitleColor(.white, for: .normal)
    }
}
