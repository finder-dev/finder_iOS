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
}
