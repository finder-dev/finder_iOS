//
//  DebateTableView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/14.
//

import Foundation
import UIKit

final class DebateTableView: UITableView {
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
        register(DiscussTableViewCell.self,
                 forCellReuseIdentifier: DiscussTableViewCell.identifier)
    }
}

