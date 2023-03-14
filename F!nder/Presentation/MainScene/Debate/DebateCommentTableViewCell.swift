//
//  DebateCommentTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/20.
//

import UIKit
import SnapKit

protocol CommentCellDelegate {
    func report(answerID:Int)
    func delete(answerID:Int)
}

class DebateCommentTableViewCell: UITableViewCell {

    static let identifier = " DebateCommentTableViewCell"
    
    let innerView = UIView()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
    let commentLabel = UILabel()
    let dotButton = UIButton()
    
    var userID: Int = -1
    var answerID: Int = -1
    
    var delegate: CommentCellDelegate!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(data:answerHistDtos) {
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
//        userNameLabel.text = data.userNickname
        timeLabel.text = data.createTime
        commentLabel.text = data.answerContent
        userID = data.userId
        answerID = data.answerId
        
    }
    
    func setupCell() {
        userMBTILabel.text = "test"
        userNameLabel.text = "test"
        timeLabel.text = "test"
        commentLabel.text = "test"
    }
}

extension DebateCommentTableViewCell {
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
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
       
    }
    
    func attribute() {
        innerView.backgroundColor = .white
        
        [userNameLabel,userMBTILabel,timeLabel].forEach {
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        }
        
        commentLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        commentLabel.textColor = .black1
        commentLabel.numberOfLines = 0
        
        commentLabel.text = "test"
        
        dotButton.setImage(UIImage(named: "icon-dots-mono"), for: .normal)
        dotButton.addTarget(self, action: #selector(didTapDotButton), for: .touchUpInside)
    }
    
    @objc func didTapDotButton() {
        let userId = UserDefaultsData.userId
        
        if self.userID != userId {
            print("userID 다름")
            self.delegate.report(answerID: self.answerID)
        } else {
            print("userID 같음")
            self.delegate.delete(answerID: self.answerID)
        }
    }
    
}
