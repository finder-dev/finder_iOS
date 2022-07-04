//
//  HomeViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit

/*
 * 메인 탭 바 진입 시 가장 먼저 보이는 홈 뷰 컨트롤러입니다.
 */
class HomeViewController: UIViewController {
    
    var mainLogoImageView = UIImageView()
    var alarmButton = UIButton()
    var messageButton = UIButton()
    var searchView = UIView()
    var searchImageView = UIImageView()
    var searchLabel = UILabel()
    var userInfoLabel = UILabel()
    var mbtiInfoLabel = UILabel()
    var mbtiImageView = UIImageView()
    
    var lineView = UIView()
    var balanceGameLabel = UILabel()
    var balaceGameTitleLabel = UILabel()
    var balanceGameTimeLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true

        layout()
        attribute()
    }
}

private extension HomeViewController {
    func layout() {
        
        [mainLogoImageView,
         alarmButton,
         messageButton,
         searchView,
         userInfoLabel,
         mbtiInfoLabel,
         mbtiImageView,
         lineView,
         balanceGameLabel].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        mainLogoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24.0)
            $0.top.equalTo(safeArea.snp.top).offset(10.0)
        }
        
        alarmButton.snp.makeConstraints {
            $0.centerY.equalTo(mainLogoImageView)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(24.0)
        }

        messageButton.snp.makeConstraints {
            $0.centerY.equalTo(mainLogoImageView)
            $0.trailing.equalTo(alarmButton.snp.leading).offset(-12.0)
            $0.width.height.equalTo(24.0)
        }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(30.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(54.0)
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(36.0)
            $0.leading.equalTo(searchView)
        }
        
        mbtiInfoLabel.snp.makeConstraints {
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(searchView)
        }
        
        mbtiImageView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(8.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.equalTo(155.0)
            $0.height.equalTo(140.0)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(2.0)
            $0.top.equalTo(mbtiImageView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        balanceGameLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(53.0)
            $0.centerX.equalToSuperview()
        }
        
        searchBarLayout()
        balanceGameLayout()
    }
    
    func attribute() {
        mainLogoImageView.image = UIImage(named: "main_logo")
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        alarmButton.setImage(UIImage(named: "ic_notification"), for: .normal)

        searchView.layer.borderWidth = 2.0
        searchView.layer.borderColor = UIColor.mainTintColor.cgColor
        
        userInfoLabel.text = "INFJ 수완"
        userInfoLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        userInfoLabel.textColor = .blackTextColor
        
        mbtiInfoLabel.text = "오늘은 하고 싶은 말 \n다 하고 오셨나요?"
        mbtiInfoLabel.numberOfLines = 0
        mbtiInfoLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        mbtiInfoLabel.textColor = .textGrayColor
        mbtiInfoLabel.setLineHeight(lineHeight: 25.0)
        
        mbtiImageView.image = UIImage(named: "img_infj")
        
        lineView.backgroundColor = .mainTintColor
        
        balanceGameLabel.text = "🔥HOT한 밸런스 게임! 당신의 선택은?"
        balanceGameLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        searchBarAttribute()
        balanceGameAttribute()
    }
}

// SearchBar UI 설정
private extension HomeViewController {
    
    func searchBarLayout() {
        [searchImageView,
         searchLabel].forEach {
            self.searchView.addSubview($0)
        }
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchView)
            $0.leading.equalTo(searchView).inset(20.0)
            $0.width.height.equalTo(24.0)
        }
        
        searchLabel.snp.makeConstraints {
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(searchView)
        }
    }
    
    func searchBarAttribute() {
        searchImageView.image = UIImage(named: "search")
        
        searchLabel.text = "알고싶은 MBTI가 있나요?"
        searchLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        searchLabel.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchView))
        searchView.addGestureRecognizer(gesture)
    }
    
    @objc func didTapSearchView() {
        print("didtapSearchView")
        let nextVC = SearchViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

// 밸런스게임 UI 설정
private extension HomeViewController {
    func balanceGameLayout() {
        [balaceGameTitleLabel,balanceGameTimeLabel].forEach {
            self.view.addSubview($0)
        }
        
        balaceGameTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(balanceGameLabel.snp.bottom).offset(20.0)
        }
        
        balanceGameTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(balaceGameTitleLabel.snp.bottom).offset(4.0)
        }
    }
    
    func balanceGameAttribute() {
        balaceGameTitleLabel.text = "친구의 깻잎, 19장이 엉겨붙었는데 \n애인이 떼줘도 된다?"
        balaceGameTitleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        balaceGameTitleLabel.textColor = .blackTextColor
        balaceGameTitleLabel.textAlignment = .center
        balaceGameTitleLabel.numberOfLines = 0
        
        balanceGameTimeLabel.text = "남은시간 D-3"
        balanceGameTimeLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        balanceGameTimeLabel.textColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
    }
}
