//
//  MBTICollectionView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import Foundation
import UIKit

final class MBTICollectionView: UICollectionView {
    
    convenience init() {
        self.init(frame: .zero, collectionViewLayout: MBTICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupView()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        allowsMultipleSelection = false
        register(MBTICollectionViewCell.self,
                 forCellWithReuseIdentifier: MBTICollectionViewCell.reuseIdentifier)
    }
}
