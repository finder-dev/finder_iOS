//
//  DebateListHeaderView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/14.
//

import UIKit
import SnapKit

final class DebateListHeaderView: UIView {
    
    let categoryButton = UIButton()
    let categoryLabel = FinderLabel(text: "불나게 진행중인 토론",
                                    font: .systemFont(ofSize: 18.0, weight: .bold))
    let characterImageview = UIImageView()
    let lineView = BarView(barHeight: 3.0, barColor: .primary)
    
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

private extension DebateListHeaderView {
    func addView() {
        [categoryButton, categoryLabel, characterImageview, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    func setupLayout() {
        
        self.snp.makeConstraints {
            $0.height.equalTo(76.5)
        }
        
        characterImageview.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15.0)
        }
        
        categoryButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(lineView.snp.top).offset(-17.5)
        }
        
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryButton)
            $0.leading.equalTo(categoryButton.snp.trailing).offset(8.0)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupView() {
        categoryButton.setImage(UIImage(named: "btn_caretleft"), for: .normal)
        characterImageview.image = UIImage(named: "Frame 986295")
    }
}
