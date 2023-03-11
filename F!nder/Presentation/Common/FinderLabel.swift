//
//  FinderLabel.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import Foundation
import UIKit

final class FinderLabel: UILabel {
    
    /// textColor = black, textAlignment = left로 default 설정
    public init(text: String,
                font: UIFont,
                textColor: UIColor = .black,
                textAlignment: NSTextAlignment = .left) {
                    
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.font = font
        self.textColor = textColor
        self.text = text
        self.textAlignment = textAlignment
        self.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
