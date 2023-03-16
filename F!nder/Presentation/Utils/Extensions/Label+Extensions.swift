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
            style.alignment = self.textAlignment
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight)/4,
                .font: self.font
            ]
                
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    func setFont(targetString: String, font: UIFont) {
        let fullText = self.text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
    
        attributedString.addAttribute(.font, value: font, range: range)
        self.attributedText = attributedString
    }
}
