//
//  Label+Extensions.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import Foundation
import UIKit

extension UILabel {
    func setLineHeight(lineHeight:CGFloat) {
        if let text = self.text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight)/4,
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}
