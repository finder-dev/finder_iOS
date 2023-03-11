//
//  FinderTextField.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/12.
//

import Foundation
import UIKit

final class FinderTextField: UITextField {
    
    public init(placeHolder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeHolder
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute() {
        translatesAutoresizingMaskIntoConstraints = false
        
        self.heightAnchor.constraint(equalToConstant: 54.0).isActive = true
        self.layer.borderColor = UIColor.textFieldBorder.cgColor
        self.layer.borderWidth = 1.0
        self.addLeftPadding(padding: 20.0)
    }
}
