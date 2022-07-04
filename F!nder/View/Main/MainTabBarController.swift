//
//  MainTabBarController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import Foundation
import UIKit

/*
 * 탭 별 뷰컨트롤러를 관리하는 메인 텝 바 컨트롤러입니다.
 */
class MainTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
        addShadowToTabBar()
    }
    
    func addShadowToTabBar() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
        
        self.tabBar.layer.applyShadow(color: .lightGray, alpha: 0.3, x: 0, y: 0, blur: 12)
    }
    
    private func setUpTabBar() {
        
        let firstViewController = HomeViewController()
        let secondViewController = DiscussViewController()
        let thirdViewController = CommunityViewController()
        let fourthViewController = SavedViewController()
        let fifthViewController = UserViewController()

        firstViewController.tabBarItem.title = "홈"
        secondViewController.tabBarItem.title = "토론"
        thirdViewController.tabBarItem.title = "커뮤니티"
        fourthViewController.tabBarItem.title = "저장"
        fifthViewController.tabBarItem.title = "마이"
        
        /*
        firstViewController = UIImage(named: "First") // TabBar Item 의 이미지
         secondViewController = UIImage(named: "Second")
         thirdViewController = UIImage(named: "Third")
         fourthViewController = UIImage(named: "Fourth")
         fifthViewController = UIImage(named: "Fifth")
         
         */
        
        viewControllers = [firstViewController,
                           secondViewController,
                           thirdViewController,
                           fourthViewController,
                           fifthViewController]
        
    }
}
