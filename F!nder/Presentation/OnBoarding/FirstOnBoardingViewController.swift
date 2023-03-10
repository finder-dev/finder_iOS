//
//  FirstOnboardingViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/06/21.
//

import UIKit
import SnapKit
import Then

class FirstOnBoardingViewController: UIViewController {
    
    let mainTitleLabel = UILabel()
    let smallLabel = UILabel()
    let mainImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()
        // Do any additional setup after loading the view.
    }
}

private extension FirstOnBoardingViewController {
    func layout() {
        [mainTitleLabel,
         smallLabel,
         mainImageView
        ].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        let topMargin = 40.0
        
        mainTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(safeArea).inset(topMargin)
        }
        
        smallLabel.snp.makeConstraints {
            $0.leading.equalTo(mainTitleLabel)
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(12.0)
        }
        
        mainImageView.snp.makeConstraints {
//            $0.top.equalTo(smallLabel.snp.bottom).offset(58.0)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(302.0)
            $0.height.equalTo(239.0)
        }
    }
    
    func attribute() {
        mainTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        mainTitleLabel.text = "궁금한 MBTI한테 \n바로 물어보세요"
        mainTitleLabel.textColor = .black1
        mainTitleLabel.numberOfLines = 0
        mainTitleLabel.font = .systemFont(ofSize: 24.0, weight: .bold)
        
        smallLabel.translatesAutoresizingMaskIntoConstraints = false
        smallLabel.text = "오해와 진실! 여기서 다 풀어요"
        smallLabel.textColor = .onboardGrayTextColor
        smallLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
//        mainImageView.backgroundColor = .yellow
        mainImageView.image = UIImage(named: "img_onboarding1")
        
    }
}
