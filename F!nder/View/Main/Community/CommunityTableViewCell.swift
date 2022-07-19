//
//  CommunityTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/11.
//

import UIKit
import SnapKit

class CommunityTableViewCell: UITableViewCell {
    
    static let identifier = "CommunityTableViewCell"
    
    let innerView = UIView()
    
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let mbtiCategoryLabel = UILabel()
    let questionImageView = UIImageView()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
    
    let lineView = UIView()
    let commentLabel = UILabel()
    let commentImageView = UIImageView()
    let recommentButton = UIButton()
    let recommentLabel = UILabel()
    
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

    }
    
    func setupCellData(data: content) {
        mbtiCategoryLabel.text = data.communityMBTI
        titleLabel.text = data.communityTitle
        contentLabel.text = data.communityContent
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
        timeLabel.text = data.createTime
        recommentLabel.text = "\(data.likeCount)"
        commentLabel.text = "\(data.answerCount)"
                
        if data.likeUser {
            recommentButton.setImage(UIImage(named: "icon-thumb-up-mono"), for: .normal)
        }
        
        if !data.isQuestion {
            questionImageView.isHidden = true
        } else {
            questionImageView.isHidden = false
        }
    }
}

private extension CommunityTableViewCell {
    func layout() {
        self.contentView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(265.5)
        }
                
        [mbtiCategoryLabel,
         questionImageView,
         titleLabel,
         contentLabel,
         userMBTILabel,
         userNameLabel,
         timeLabel,
         lineView,
         recommentButton,
         recommentLabel,
         commentImageView,
         commentLabel].forEach {
            innerView.addSubview($0)
        }

        mbtiCategoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(15.5)
            $0.width.equalTo(43.0)
            $0.height.equalTo(30.0)
        }
        
        questionImageView.snp.makeConstraints {
            $0.leading.equalTo(mbtiCategoryLabel.snp.trailing).offset(8.0)
            $0.centerY.equalTo(mbtiCategoryLabel)
            $0.height.equalTo(34.0)
            $0.width.equalTo(47.0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(mbtiCategoryLabel)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(mbtiCategoryLabel.snp.bottom).offset(20.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.leading.equalTo(mbtiCategoryLabel)
            $0.top.equalTo(contentLabel.snp.bottom).offset(16.0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userMBTILabel.snp.trailing)
            $0.top.equalTo(userMBTILabel)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(userMBTILabel)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(15.5)
        }
        
        recommentButton.snp.makeConstraints {
            $0.leading.equalTo(userMBTILabel)
            $0.width.height.equalTo(24.0)
            $0.top.equalTo(lineView.snp.bottom).offset(15.5)
        }
        
        recommentLabel.snp.makeConstraints {
            $0.leading.equalTo(recommentButton.snp.trailing).offset(4.0)
            $0.centerY.equalTo(recommentButton)
        }
        
        commentImageView.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.centerY.equalTo(recommentButton)
            $0.leading.equalTo(recommentLabel.snp.trailing).offset(24.0)
        }
        
        commentLabel.snp.makeConstraints {
            $0.leading.equalTo(commentImageView.snp.trailing).offset(4.0)
            $0.centerY.equalTo(commentImageView)
        }
    }
    
    func attribute() {
        questionImageView.image = UIImage(named: "Group 986359")
        
        mbtiCategoryLabel.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        mbtiCategoryLabel.layer.cornerRadius = 5.0
        mbtiCategoryLabel.textColor = .blackTextColor
        mbtiCategoryLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
        mbtiCategoryLabel.textAlignment = .center
        
        titleLabel.textColor = .blackTextColor
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
//        timeLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        contentLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        contentLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        contentLabel.numberOfLines = 2

        [userMBTILabel,userNameLabel,timeLabel].forEach {
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }
        
        lineView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)

        recommentButton.setImage(UIImage(named: "icon-thumb-up"), for: .normal)
        recommentButton.isEnabled = false
        commentImageView.image = UIImage(named: "icon-chat-bubble-dots-mono")
        
        [recommentLabel,commentLabel].forEach {
            $0.font = .systemFont(ofSize: 14.0, weight: .bold)
            $0.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        }
    }
    
}
