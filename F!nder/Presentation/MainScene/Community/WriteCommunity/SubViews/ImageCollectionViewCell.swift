//
//  ImageCollectionViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/22.
//

import UIKit
import SnapKit

final class ImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    private let imageView = UIImageView()
    let eraseButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(data: UIImage) {
        self.imageView.image = data
    }
}

private extension ImageCollectionViewCell {
    func addView() {
        [imageView, eraseButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout(){
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        eraseButton.snp.makeConstraints {
            $0.width.height.equalTo(26.0)
            $0.top.trailing.equalToSuperview().inset(4)
        }
    }
    
    func setupView() {
        self.layer.borderColor = UIColor.grey4.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        eraseButton.setImage(UIImage(named: "Group 986377"), for: .normal)
    }
}
