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
    
    private let innerView = UIView()
    private let discussLabel = FinderLabel(text: "",
                                           font: .systemFont(ofSize: 18.0, weight: .medium))
    private let personImageView = UIImageView()
    private let peopleCountLabel = FinderLabel(text: "",
                                               font: .systemFont(ofSize: 14.0, weight: .regular),
                                               textColor: .grey6)
    private let timeLabel = FinderLabel(text: "",
                                        font: .systemFont(ofSize: 14.0, weight: .bold),
                                        textColor: .primary)
    private let barView = BarView(barHeight: 1.0, barColor: .grey9)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addView()
        setupView()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        [discussLabel, personImageView, peopleCountLabel, timeLabel, barView].forEach {
            innerView.addSubview($0)
        }
    }
    
    func setLayout() {
        innerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(10)
        }
        
        discussLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview().inset(20.0)
        }
        
        personImageView.snp.makeConstraints {
            $0.width.height.equalTo(20.0)
            $0.leading.bottom.equalToSuperview().inset(20.0)
            $0.top.equalTo(discussLabel.snp.bottom).offset(17.0)
        }
        
        peopleCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(personImageView)
            $0.leading.equalTo(personImageView.snp.trailing).offset(4.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(personImageView)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        barView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupView() {
        backgroundColor = .grey10
        innerView.backgroundColor = .white
        discussLabel.numberOfLines = 2
        personImageView.image = UIImage(named: "icon-user-mono")
    }
}
