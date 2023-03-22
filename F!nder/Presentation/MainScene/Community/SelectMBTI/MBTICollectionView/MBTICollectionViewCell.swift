//
//  MBTICollectionViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import UIKit
import SnapKit

final class MBTICollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "MBTICollectionViewCell"
    
    private let titleLabel = FinderLabel(text: "",
                                         font: .systemFont(ofSize: 16.0, weight: .medium),
                                         textColor: .grey6,
                                         textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .primary : .grey6
        }
    }
    
    func setupCell(data: MBTI) {
        titleLabel.text = data.rawValue
    }
}

private extension MBTICollectionViewCell {
    func addView() {
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.centerY.equalToSuperview()
        }
    }
}
