//
//  CommunitySortView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/21.
//

import UIKit
import SnapKit

final class CommunitySortView: UIView {
    
    let caretButton = UIButton()
    let mbtiLabel = FinderLabel(text: "전체",
                                font: .systemFont(ofSize: 14.0, weight: .medium),
                                textColor: .primary)
    let latestButton = UIButton()
    let commentButton = UIButton()
    private let barView = BarView(barHeight: 1.0, barColor: .grey11)
    private let mbtiBarView = BarView(barHeight: 3.0, barColor: .primary)
    
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

private extension CommunitySortView {
    func addView() {
        [caretButton, mbtiLabel, latestButton, commentButton, barView, mbtiBarView].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(51.5)
        }
        
        caretButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(3.5)
        }
        
        mbtiLabel.snp.makeConstraints {
            $0.leading.equalTo(caretButton.snp.trailing).offset(24.0)
            $0.bottom.equalTo(mbtiBarView.snp.top).offset(-7.0)
        }
        
        mbtiBarView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalTo(mbtiLabel)
        }
        
        commentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(7.5)
        }
        
        latestButton.snp.makeConstraints {
            $0.trailing.equalTo(commentButton.snp.leading).offset(-8.0)
            $0.bottom.equalTo(commentButton)
        }
        
        barView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupView() {
        caretButton.setImage(UIImage(named: "btn_caretleft"), for: .normal)
        commentButton.setTitle("  댓글순", for: .normal)
        latestButton.setTitle("  최신순", for: .normal)
        
        [commentButton, latestButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
            $0.setImage(UIImage(named: "Ellipse 4250"), for: .disabled)
            $0.setImage(UIImage(named: "Ellipse 4249"), for: .normal)
            $0.setTitleColor(UIColor.grey3, for: .disabled)
            $0.setTitleColor(UIColor.black1, for: .normal)
            $0.addTarget(self, action: #selector(tapSortButton(sender:)), for: .touchUpInside)
        }
        
        commentButton.isEnabled = false
        latestButton.isEnabled = true
    }
    
    @objc func tapSortButton(sender: UIButton) {
        if sender == commentButton {
            latestButton.isEnabled = true
            commentButton.isEnabled = false
        } else {
            latestButton.isEnabled = false
            commentButton.isEnabled = true
        }
    }
}
