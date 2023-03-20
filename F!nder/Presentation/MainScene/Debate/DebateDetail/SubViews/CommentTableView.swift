//
//  CommentTableView.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/15.
//

import UIKit

final class CommentTableView: UITableView {
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
        register(CommentTableViewCell.self,
                 forCellReuseIdentifier: CommentTableViewCell.identifier)
        
        self.isScrollEnabled = false
        self.rowHeight = UITableView.automaticDimension
        self.estimatedRowHeight = 130.0
    }
}
