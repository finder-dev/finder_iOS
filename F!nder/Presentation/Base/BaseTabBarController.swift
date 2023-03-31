//
//  BaseTabBarController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/31.
//

import Foundation
import UIKit

class BaseTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowToTabBar()
    }
    
    func addShadowToTabBar() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        
        self.tabBar.layer.applyShadow(color: .lightGray, alpha: 0.3, x: 0, y: 0, blur: 12)
        self.tabBar.tintColor = .primary
    }
}
