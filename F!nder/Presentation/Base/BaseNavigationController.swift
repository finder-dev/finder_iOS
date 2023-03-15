//
//  BaseNavigationController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/14.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setNavigationBarAppearance()
    }
}

private extension BaseNavigationController {
    
    func setNavigationBarAppearance() {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        let barButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        barButtonAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 14.0, weight: .medium)]
        
        let backButtonImage = UIImage(named: "backButton")?.withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -8.0, bottom: 0.0, right: 0.0))
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .bold)
        ]
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backButtonAppearance = backButtonAppearance
        appearance.buttonAppearance = barButtonAppearance
        appearance.setBackIndicatorImage(backButtonImage,
                                         transitionMaskImage: backButtonImage)
        appearance.shadowColor = .clear
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = attrs
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
}
