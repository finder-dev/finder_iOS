//
//  MBTICollectionViewFlowLayout.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import Foundation
import UIKit

final class MBTICollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private let itemSpacing = 0.0

    override init() {
        super.init()
        scrollDirection = .vertical
        minimumInteritemSpacing = itemSpacing
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else {
            return
        }
        
        let cellWidth = collectionView.bounds.width / 2
        self.itemSize = CGSize(width: cellWidth, height: 55.0)
    }
}
