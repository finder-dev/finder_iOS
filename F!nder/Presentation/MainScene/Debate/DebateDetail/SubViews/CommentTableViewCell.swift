//
//  DebateCommentTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/20.
//

import UIKit
import SnapKit

protocol CommentCellDelegate {
    func report(userID:Int)
    func delete(commentID:Int)
}

final class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"
    
    let innerView = UIView()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
    let commentLabel = FinderLabel(text: "",
                                   font: .systemFont(ofSize: 14.0, weight: .regular),
                                   textColor: .black1)
    let dotButton = UIButton()
    
    var userID: Int = -1
    var answerID: Int = -1
    
    var delegate: CommentCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(data: Answer) {
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
        timeLabel.text = data.createTime
        commentLabel.text = data.answerContent
        userID = data.userId
        answerID = data.answerId
    }
}

extension CommentTableViewCell {
    func layout() {
        self.contentView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [userMBTILabel,userNameLabel,timeLabel,commentLabel,dotButton].forEach {
            innerView.addSubview($0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.equalTo(22.0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userMBTILabel)
            $0.leading.equalTo(userMBTILabel.snp.trailing)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(userMBTILabel)
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(8.0)
        }
        
        dotButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(24.0)
            $0.centerY.equalTo(userMBTILabel)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userMBTILabel.snp.bottom).offset(4.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(60.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
    
    func attribute() {
        innerView.backgroundColor = .white
        
        [userNameLabel,userMBTILabel,timeLabel].forEach {
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        }
        
        dotButton.setImage(UIImage(named: "icon-dots-mono"), for: .normal)
        dotButton.addTarget(self, action: #selector(didTapDotButton), for: .touchUpInside)
    }
    
    @objc func didTapDotButton() {
        let userId = UserDefaultsData.userId
        
        if self.userID != userId {
            self.delegate?.report(userID: self.answerID)
        } else {
            self.delegate?.delete(commentID: self.answerID)
        }
    }
}
