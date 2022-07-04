//
//  HomeViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var mainLogoImageView = UIImageView()
    var alarmButton = UIButton(type: .system)
    var messageButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true

        layout()
        attribute()
    }
}

extension HomeViewController {
    func layout() {
        
        [mainLogoImageView,
         alarmButton,
         messageButton].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        mainLogoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(safeArea.snp.top).offset(10.0)
        }
    }
    
    func attribute() {
        mainLogoImageView.image = UIImage(named: "main_logo")
    }
}
