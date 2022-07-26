//
//  SceneDelegate.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/11.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        var rootVC = UIViewController()
        
        if !Storage.isFirstTime() {
            rootVC = LoginViewController()
//            rootVC = OnBoardingViewController()
        } else {
            rootVC = OnBoardingViewController()
        }
        
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
    }
    
    // MARK : - kakao 소셜 로그인
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

}

