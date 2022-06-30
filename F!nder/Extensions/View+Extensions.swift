//
//  View+Extensions.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/30.
//

import Foundation
import UIKit

extension UIView {
    func traverseRadius(_ radius: Float) {
        layer.cornerRadius = CGFloat(radius)

        for subview: UIView in subviews {
            subview.traverseRadius(radius)
        }
    }
}
