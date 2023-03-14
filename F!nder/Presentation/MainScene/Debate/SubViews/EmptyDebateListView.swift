//
//  EmptyDebateListView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/14.
//

import UIKit
import SnapKit

final class EmptyDebateListView: UIView {

    private let emptyImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyDebateListView {
    func addView() {
        self.addSubview(emptyImageView)
    }
    
    func setupLayout(){
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(66.5)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setupView() {
        emptyImageView.image = UIImage(named: "noDiscuss")
    }
}
