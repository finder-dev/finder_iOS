//
//  SearchBarView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/10.
//

import UIKit
import SnapKit

final class SearchBarView: UIView {
    let searchImageView = UIImageView()
    let searchLabel = FinderLabel(text: "알고싶은 MBTI가 있나요?",
                                  font: .systemFont(ofSize: 14.0, weight: .medium),
                                  textColor: .grey3)
    
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

private extension SearchBarView {
    func addView() {
        [searchImageView,searchLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func setupView() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.primary.cgColor
        
        searchImageView.image = UIImage(named: "search")
    }
    
    func setupLayout() {
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(15.0)
            $0.width.height.equalTo(24.0)
        }
        
        searchLabel.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8.0)
            $0.centerY.equalToSuperview()
        }
    }
}
