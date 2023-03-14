//
//  DiscussTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/13.
//

import UIKit
import SnapKit

final class DebateTableViewCell: UITableViewCell {
    
    static let identifier = "DebateTableViewCell"
    
    let innerView = UIView()
    let discussLabel = FinderLabel(text: "",
                                   font: .systemFont(ofSize: 18.0, weight: .medium))
    let personImageView = UIImageView()
    let peopleCountLabel = FinderLabel(text: "",
                                       font: .systemFont(ofSize: 14.0, weight: .regular),
                                       textColor: .grey6)
    let timeLabel = FinderLabel(text: "",
                                font: .systemFont(ofSize: 14.0, weight: .bold),
                                textColor: .primary)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addView()
        setupView()
        setLayout()
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
    
    func setupCell(data: DebateTableModel) {
        discussLabel.text = data.debateTitle
        peopleCountLabel.text = data.joinState
        timeLabel.text = data.deadLine
    }
}

private extension DebateTableViewCell {
    
    func addView(){
        self.contentView.addSubview(innerView)
        
        [discussLabel, personImageView, peopleCountLabel, timeLabel].forEach {
            innerView.addSubview($0)
        }
    }
    
    func setLayout() {
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(130)
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
    
    func setupView() {
        backgroundColor = UIColor(red: 247/255, green: 248/255, blue: 252/255, alpha: 1.0)
        innerView.backgroundColor = .white
        discussLabel.numberOfLines = 2
        personImageView.image = UIImage(named: "icon-user-mono")
    }
}
