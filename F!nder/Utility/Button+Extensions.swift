//
//  Button+Extensions.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/16.
//

import Foundation
import UIKit

extension UIButton {
    
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                        value: NSUnderlineStyle.single.rawValue,
                                        range: NSRange(location: 0, length: title.count)
            )
        setAttributedTitle(attributedString, for: .normal)
    }
    
}
