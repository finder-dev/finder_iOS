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
    public init(buttonText: String, buttonHeight: CGFloat) {
                    
        super.init(frame: .zero)
        
        self.setTitle(buttonText, for: .normal)
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .mainTintColor
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
    }
}
