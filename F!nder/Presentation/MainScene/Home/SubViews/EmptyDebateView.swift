//
//  EmptyDebateView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import UIKit
import SnapKit

final class EmptyDebateView: UIView {
    let emptyImageView = UIImageView()
    let emptyLabel = FinderLabel(text: "아직 생성된 토론이 없습니다!\n첫 토론의 주인공이 돼보세요! GOGO!",
                                 font: .systemFont(ofSize: 14.0, weight: .regular),
                                 textColor: .grey3, textAlignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension EmptyDebateView {
    func addView() {
        [emptyImageView, emptyLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        emptyImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(4.0)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16.0)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    func setupView() {
        emptyImageView.image = UIImage(named: "main character grey_home")
    }
}
