//
//  OnBoardingViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/16.
//

import UIKit
import Onboarder

class OnBoardingViewController: UIViewController {
    
    let pages : [OBPage] = [
        OBPage(color: .white, imageName: "img_onboarding1", label: ("",""))
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // Do any additional setup after loading the view.
    }

}
