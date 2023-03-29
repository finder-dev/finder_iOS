//
//  CommentTextFieldView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/29.
//

import UIKit
import SnapKit

final class CommentTextFieldView: UIView {
    let commentTextField = UITextField()
    let addCommentButton = UIButton()
    
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

private extension CommentTextFieldView {
    func addView() {
        [commentTextField, addCommentButton].forEach {
            self.addSubview($0)
        }
    }
    
    func setLayout() {
        commentTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview().inset(18.0)
            $0.height.equalTo(42.0)
        }
        
        addCommentButton.snp.makeConstraints {
            $0.width.height.equalTo(34.0)
            $0.trailing.top.bottom.equalTo(commentTextField).inset(4.0)
        }
    }
    
    func setupView() {
        self.backgroundColor = .white
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.grey11.cgColor
        
        commentTextField.backgroundColor = .grey11
        commentTextField.layer.cornerRadius = 20.0
        commentTextField.addLeftPadding(padding: 16.0)
        
        addCommentButton.backgroundColor = .grey1
        addCommentButton.setImage(UIImage(named: "ic:baseline-arrow-forward") ?? UIImage(),
                                  for: .normal)
        addCommentButton.layer.cornerRadius = 17.0
    }
}
