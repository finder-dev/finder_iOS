//
//  TextField+Extensions.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/25.
//

import Foundation
import UIKit

extension UITextField {
    func addLeftPadding(padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func setRightViewIcon(icon: UIImage) {
        let btnView = UIButton(frame: CGRect(x: 0, y: 0, width: ((self.frame.height) * 0.70), height: ((self.frame.height) * 0.70)))
        btnView.setImage(icon, for: .normal)
        btnView.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        btnView.backgroundColor = .mainTintColor
        print(((self.frame.height) * 0.70)/2)
        btnView.layer.cornerRadius = ((self.frame.height) * 0.70)/2
        self.rightViewMode = .always
        self.rightView = btnView
    }
}
