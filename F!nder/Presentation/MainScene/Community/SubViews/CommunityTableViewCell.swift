//
//  CommunityTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/11.
//

import UIKit
import SnapKit

final class CommunityTableViewCell: UITableViewCell {
    
    static let identifier = "CommunityTableViewCell"
    
    let innerView = UIView()
    let titleLabel = FinderLabel(text: "",
                                 font: .systemFont(ofSize: 18.0, weight: .medium),
                                 textColor: .black1)
    let contentLabel = FinderLabel(text: "",
                                   font: .systemFont(ofSize: 16.0, weight: .regular),
                                   textColor: .grey6)
    let mbtiCategoryView = BarView(barHeight: 30.0,
                                   barColor: .grey11.withAlphaComponent(0.5))
    let mbtiCategoryLabel = FinderLabel(text: "",
                                        font: .systemFont(ofSize: 12.0, weight: .medium),
                                        textColor: .black1,
                                        textAlignment: .center)
    let questionImageView = UIImageView()
    let userMBTILabel = UILabel()
    let dotView = BarView(barHeight: 4.0, barColor: .grey6)
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
    let commentLabel = FinderLabel(text: "",
                                   font: .systemFont(ofSize: 14.0, weight: .bold),
                                   textColor: .grey13)
    let commentImageView = UIImageView()
    let recommentButton = UIButton()
    let lineView1 = BarView(barHeight: 1.0, barColor: .grey11)
    let lineView2 = BarView(barHeight: 1.0, barColor: .grey12)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        attribute()
        setLayout()
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
        userNameLabel.text = data.userNickname
        timeLabel.text = data.createTime
        commentLabel.text = "\(data.answerCount)"
        recommentButton.setTitle(" \(data.likeCount)", for: .normal)
        
        recommentButton.isEnabled = data.likeUser ? true : false
        questionImageView.isHidden = data.isQuestion ? false : true
    }
}

private extension CommunityTableViewCell {
    
    func addView() {
        self.contentView.addSubview(innerView)
        
        [mbtiCategoryView, questionImageView, titleLabel, contentLabel, userMBTILabel, dotView,
         userNameLabel, timeLabel,lineView1, recommentButton, commentImageView,
         commentLabel, lineView2].forEach {
            innerView.addSubview($0)
        }
        
        mbtiCategoryView.addSubview(mbtiCategoryLabel)
    }
    
    func setLayout() {

        innerView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }

        mbtiCategoryView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(15.5)
            $0.width.equalTo(43.0)
        }
        
        mbtiCategoryLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        questionImageView.snp.makeConstraints {
            $0.leading.equalTo(mbtiCategoryView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(mbtiCategoryView)
            $0.height.equalTo(34.0)
            $0.width.equalTo(47.0)
        }
        
        titleLabel.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(mbtiCategoryLabel.snp.bottom).offset(20.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.leading.equalTo(mbtiCategoryView)
            $0.top.equalTo(contentLabel.snp.bottom).offset(16.0)
        }
        
        dotView.snp.makeConstraints {
            $0.width.equalTo(4.0)
            $0.leading.equalTo(userMBTILabel.snp.trailing).offset(8.0)
            $0.centerY.equalTo(userMBTILabel)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(dotView.snp.trailing).offset(8.0)
            $0.top.equalTo(userMBTILabel)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(userMBTILabel)
        }
        
        lineView1.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(userMBTILabel.snp.bottom).offset(15.5)
        }
        
        recommentButton.snp.makeConstraints {
            $0.leading.equalTo(userMBTILabel)
            $0.height.equalTo(24.0)
            $0.top.equalTo(lineView1.snp.bottom).offset(15.5)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        commentImageView.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.centerY.equalTo(recommentButton)
            $0.leading.equalTo(recommentButton.snp.trailing).offset(24.0)
        }
        
        commentLabel.snp.makeConstraints {
            $0.leading.equalTo(commentImageView.snp.trailing).offset(4.0)
            $0.centerY.equalTo(commentImageView)
        }
        
        lineView2.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func attribute() {
        backgroundColor = .grey10
        innerView.backgroundColor = .white
        
        questionImageView.image = UIImage(named: "Group 986359")
        commentImageView.image = UIImage(named: "icon-chat-bubble-dots-mono")
        mbtiCategoryView.layer.cornerRadius = 5.0
        dotView.layer.cornerRadius = 2.0
        titleLabel.numberOfLines = 1
        contentLabel.numberOfLines = 2
        contentLabel.setLineHeight(lineHeight: 24.0)
        
        [userMBTILabel,userNameLabel,timeLabel].forEach {
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }
    
        recommentButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        recommentButton.setImage(UIImage(named: "icon-thumb-up-mono"), for: .normal)
        recommentButton.setImage(UIImage(named: "icon-thumb-up"), for: .disabled)
        recommentButton.setTitleColor(.grey13, for: .disabled)
        recommentButton.setTitleColor(.primary, for: .normal)
    }
}
