//
//  AlertTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/06.
//
import Foundation
import UIKit
import SnapKit

class AlertTableViewCell: UITableViewCell {
    
    static let identifier = "AlertTableViewCell"
        
    let alertImageView = UIImageView()
    let alertTitleLabel = UILabel()
    let alertTextLabel = UILabel()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        attribute()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(data:AlertTableViewCellModel) {
//        layout()
//        attribute()
        
        alertImageView.image = data.image
        alertTitleLabel.text = data.title
        alertTextLabel.text = data.text
        timeLabel.text = data.time
    }

}

extension AlertTableViewCell {
    
    func layout() {
        
        [alertImageView,
         alertTitleLabel,
         alertTextLabel,
         timeLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints {
            $0.height.equalTo(100.0)
        }
        alertImageView.snp.makeConstraints {
            $0.height.width.equalTo(40.0)
            $0.leading.equalTo(contentView).inset(20.0)
            $0.centerY.equalTo(contentView)
        }
        
        alertTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(alertImageView.snp.trailing).offset(16.0)
//            $0.trailing.equalTo(contentView.snp.trailing).inset(-20.0)
            $0.top.equalTo(contentView).inset(30.0)
            $0.width.equalTo(270.0)
        }
        
        alertTextLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(alertTitleLabel)
            $0.top.equalTo(alertTitleLabel.snp.bottom).offset(8.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.equalTo(43.0)
            $0.top.equalTo(alertTextLabel.snp.bottom)
        }
    }
    
    func attribute() {
        alertTitleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        alertTitleLabel.textColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0)
        alertTitleLabel.backgroundColor = .yellow
        
        alertTextLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        alertTextLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        
        timeLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        timeLabel.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
    }
}
