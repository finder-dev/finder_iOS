//
//  DiscussTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/13.
//

import UIKit
import SnapKit

class DiscussTableViewCell: UITableViewCell {
    
    static let identifier = "DiscussTableViewCell"
    
    let innerView = UIView()
    
    let discussLabel = UILabel()
    let personImageView = UIImageView()
    let peopleCountLabel = UILabel()
    let timeLabel = UILabel()

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
//        innerView.backgroundColor = .yellow
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // cell간 간격 주기
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    
    func setupCell(data: debateContent) {
    
        personImageView.image = UIImage(named: "icon-user-mono")
//        timeLabel.text = "D-6"
        
        discussLabel.text = data.title
        peopleCountLabel.text = "\(data.joinCount)명 참여"
        timeLabel.text = data.deadline
    }

}

private extension DiscussTableViewCell {
    func layout() {
        self.contentView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(130)
        }
        
        [discussLabel,
         personImageView,
         peopleCountLabel,
         timeLabel].forEach {
            innerView.addSubview($0)
        }
        
        discussLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(20.0)
        }
        
        personImageView.snp.makeConstraints {
            $0.width.height.equalTo(20.0)
            $0.leading.equalTo(discussLabel)
            $0.bottom.equalToSuperview().inset(20.0)
        }
        
        peopleCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(personImageView)
            $0.leading.equalTo(personImageView.snp.trailing).offset(4.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(personImageView)
            $0.trailing.equalToSuperview().inset(20.0)
        }
    }
    
    func attribute() {
        backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1.0)
        innerView.backgroundColor = .white
        
        discussLabel.numberOfLines = 2
        discussLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        discussLabel.textColor = .black1
        
        peopleCountLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        peopleCountLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        
        timeLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        timeLabel.textColor = .primary
    }
}
