//
//  CommunityDetailView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/29.
//

import UIKit
import SnapKit

final class CommunityDetailView: UIView {
    
    let mbtiCategoryView = BarView(barHeight: 30.0,
                                   barColor: .grey11.withAlphaComponent(0.5))
    let mbtiCategoryLabel = FinderLabel(text: "INFJ",
                                        font: .systemFont(ofSize: 12.0, weight: .medium),
                                        textColor: .black1,
                                        textAlignment: .center)
    let questionImageView = UIImageView()
    let titleLabel = FinderLabel(text: "title",
                                 font: .systemFont(ofSize: 18.0, weight: .medium),
                                 textColor: .black1)
    let contentLabel = FinderLabel(text: "content",
                                   font: .systemFont(ofSize: 16.0, weight: .regular),
                                   textColor: .grey6)
    let userMBTILabel = UILabel()
    let dotView = BarView(barHeight: 4.0, barColor: .grey6)
    let userNameLabel = UILabel()
    let timeLabel = FinderLabel(text: "방금",
                                font: .systemFont(ofSize: 12.0, weight: .regular),
                                textColor: .grey6)
    let recommendButton = UIButton()
    let commentButton = UIButton()
    let lineView1 = BarView(barHeight: 1.0, barColor: .grey11)
    let lineView2 = BarView(barHeight: 1.0, barColor: .grey11)
    let lineView3 = BarView(barHeight: 1.0, barColor: .grey12)
    let emptyView = BarView(barHeight: 10.0, barColor: .grey10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        setLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addData(data: DetailCommunitySuccessDTO) {
        mbtiCategoryLabel.text = data.communityMBTI
        timeLabel.text = data.createTime
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
        titleLabel.text = data.communityTitle
        contentLabel.text = data.communityContent
        recommendButton.setTitle(" 추천 \(data.likeCount)", for: .normal)
        commentButton.setTitle("댓글 \(data.answerCount)", for: .normal)
        if !data.isQuestion {
            questionImageView.isHidden = true
        }
        recommendButton.isEnabled = data.likeUser ? true : false
    }
}

private extension CommunityDetailView {
    
    func addView() {
        [mbtiCategoryView, questionImageView, titleLabel, userMBTILabel, dotView, userNameLabel, timeLabel, lineView1, contentLabel, lineView2, recommendButton, commentButton, emptyView].forEach {
            self.addSubview($0)
        }
        
        mbtiCategoryView.addSubview(mbtiCategoryLabel)
        emptyView.addSubview(lineView3)
    }
    
    func setLayout() {
        
        mbtiCategoryView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(20)
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
            $0.leading.trailing.equalToSuperview().offset(20.0)
            $0.top.equalTo(mbtiCategoryView.snp.bottom).offset(20.0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.leading.equalTo(mbtiCategoryView)
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
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
            $0.top.equalTo(userMBTILabel.snp.bottom).offset(19.5)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom).offset(19.5)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        lineView2.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(contentLabel.snp.bottom).offset(32.0)
        }
        
        let width = UIScreen.main.bounds.width / 2 - 20
        
        recommendButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.equalTo(56.0)
            $0.width.equalTo(width)
            $0.top.equalTo(lineView2.snp.bottom)
        }
        
        commentButton.snp.makeConstraints {
            $0.leading.equalTo(recommendButton.snp.trailing)
            $0.width.equalTo(width)
            $0.height.equalTo(recommendButton)
            $0.centerY.equalTo(recommendButton)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(recommendButton.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        lineView3.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
        }
    }
    
    func setupView() {
        questionImageView.image = UIImage(named: "Group 986359")
        titleLabel.numberOfLines = 1
        
        [userMBTILabel,userNameLabel].forEach {
            $0.textColor = .grey6
            $0.font = .systemFont(ofSize: 14.0, weight: .regular)
            $0.text = "user"
        }
        
        recommendButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        recommendButton.setImage(UIImage(named: "icon-thumb-up-mono"), for: .normal)
        recommendButton.setImage(UIImage(named: "icon-thumb-up"), for: .disabled)
        recommendButton.setTitleColor(.grey13, for: .disabled)
        recommendButton.setTitleColor(.primary, for: .normal)
        recommendButton.setTitle(" 추천 2", for: .normal)
        
        commentButton.setImage(UIImage(named: "icon-chat-bubble-dots-mono"), for: .normal)
        commentButton.setTitle(" 댓글 2", for: .normal)
        commentButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        commentButton.setTitleColor(.grey13, for: .normal)
    }
}
