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
class MainTabBarController: BaseTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabBar()
    }
    
    private func setUpTabBar() {
        
        let firstViewController = BaseNavigationController(rootViewController: HomeViewController(viewModel: HomeViewModel()))
        let secondViewController = BaseNavigationController(rootViewController: DebateListViewController(viewModel: DebateListViewModel()))
        let thirdViewController = BaseNavigationController(rootViewController: CommunityViewController(viewModel: CommunityViewModel()))
        let fourthViewController = BaseNavigationController(rootViewController: SavedViewController(viewModel: SavedViewModel()))
        let fifthViewController = BaseNavigationController(rootViewController: UserViewController())

        // TabBar Item 타이틀
        firstViewController.tabBarItem.title = "홈"
        secondViewController.tabBarItem.title = "토론"
        thirdViewController.tabBarItem.title = "커뮤니티"
        fourthViewController.tabBarItem.title = "저장"
        fifthViewController.tabBarItem.title = "마이"

        // TabBar Item 이미지
        firstViewController.tabBarItem.image = UIImage(named: "7611")
        secondViewController.tabBarItem.image = UIImage(named: "Frame 7611")
        thirdViewController.tabBarItem.image = UIImage(named: "986361")
        fourthViewController.tabBarItem.image = UIImage(named: "Frame 7609")
        fifthViewController.tabBarItem.image = UIImage(named: "Frame 7618")
         
        
        viewControllers = [firstViewController,
                           secondViewController,
                           thirdViewController,
                           fourthViewController,
                           fifthViewController]
        
    }
}
