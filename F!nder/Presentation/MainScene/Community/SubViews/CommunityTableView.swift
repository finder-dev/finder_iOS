//
//  CommunityTableView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/21.
//

import Foundation
import UIKit

final class CommunityTableView: UITableView {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        separatorStyle = .none
        register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
        
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 130.0
    }
}

