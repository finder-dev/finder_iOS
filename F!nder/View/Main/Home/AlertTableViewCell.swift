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
    let innerView = UIView()
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
        
        self.contentView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        [alertImageView,
         alertTitleLabel,
         alertTextLabel,
         timeLabel].forEach {
            self.innerView.addSubview($0)
        }
        
        innerView.snp.makeConstraints {
            $0.height.equalTo(100.0)
        }
        alertImageView.snp.makeConstraints {
            $0.height.width.equalTo(40.0)
            $0.leading.equalTo(innerView).inset(20.0)
            $0.centerY.equalTo(innerView)
        }
        
        alertTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(alertImageView.snp.trailing).offset(16.0)
            $0.trailing.equalTo(innerView).inset(20.0)
            $0.top.equalTo(innerView).inset(30.0)
        }
        
        alertTextLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(alertTitleLabel)
            $0.top.equalTo(alertTitleLabel.snp.bottom).offset(8.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(alertTextLabel.snp.bottom)
        }
    }
    
    func attribute() {
        alertTitleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        alertTitleLabel.textColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0)
        
        alertTextLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        alertTextLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        
        timeLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        timeLabel.textColor = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        timeLabel.textAlignment = .right
    }
}
