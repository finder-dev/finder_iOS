//
//  DiscussViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit

class DiscussViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupHeaderView()
        layout()
        attribute()
    }
    

}


private extension DiscussViewController {
    func layout() {

    }
    
    func attribute() {
        
    }
    
    func setupHeaderView() {
        let headerLabel = UILabel()
        
        self.view.addSubview(headerLabel)
        let safeArea = self.view.safeAreaLayoutGuide
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }
        
        headerLabel.text = "토론"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
    }
}
