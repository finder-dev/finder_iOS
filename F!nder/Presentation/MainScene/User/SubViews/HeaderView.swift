//
//  HeaderView.swift
//  F!nder
//
//  Created by 장선영 on 2023/04/05.
//

import UIKit
import SnapKit

final class HeaderView: UIView {
    let closeButton = UIButton()
    let titleLabel = FinderLabel(text: "",
                                 font: .systemFont(ofSize: 16.0, weight: .bold),
                                 textColor: .black,
                                 textAlignment: .center)
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HeaderView {
    func addView() {
        [closeButton, titleLabel].forEach { self.addSubview($0) }
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(48.0)
        }
        
        closeButton.snp.makeConstraints {
            $0.height.width.equalTo(56.0)
            $0.leading.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(closeButton.snp.trailing)
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    func setupView() {
        self.backgroundColor = .white
        closeButton.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
    }
}
