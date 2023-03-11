//
//  BarView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import UIKit

final class BarView: UIView {

    convenience init(barHeight: Double, barColor: UIColor) {
        self.init()
        
        self.heightAnchor.constraint(equalToConstant: barHeight).isActive = true
        self.backgroundColor = barColor
    }
}
