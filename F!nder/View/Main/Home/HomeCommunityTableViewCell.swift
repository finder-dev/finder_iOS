//
//  HomeCommunityTableViewCell.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/07.
//

import UIKit
import SnapKit

class HomeCommunityTableViewCell: UITableViewCell {
    
    static let identifier = "HomeCommunityTableViewCell"
    
    let innerView = UIView()
    let numberLabel = UILabel()
    let communityTitleLabel = UILabel()
    
    
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
    
    func setupCell(data: HotCommunitySuccessResponse, index:Int) {
        numberLabel.text = "\(index)"
        communityTitleLabel.text = data.title
    }

}

extension HomeCommunityTableViewCell {
    func layout() {
        self.contentView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(53.0)
        }
        
        [numberLabel,communityTitleLabel].forEach {
            innerView.addSubview($0)
        }
        
        numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.width.equalTo(29.0)
        }
        
        communityTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel)
            $0.leading.equalTo(numberLabel.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().inset(21.0)
        }
    }
    
    func attribute() {
        numberLabel.backgroundColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        numberLabel.textColor = .white
        numberLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        numberLabel.textAlignment = .center
        
        communityTitleLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        communityTitleLabel.textColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0)
    }
}
