//
//  ImageCollectionViewFlowLayout.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import Foundation
import UIKit

final class ImageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let itemSpacing = 8.0

    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumInteritemSpacing = itemSpacing
        self.itemSize = CGSize(width: 80, height: 80.0)
        self.sectionInset.left = 20.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
