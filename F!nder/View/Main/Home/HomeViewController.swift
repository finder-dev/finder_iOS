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

enum balanceGameDataStatus {
    case noData
    case yesData
}

class HomeViewController: UIViewController {
    
    var mainLogoImageView = UIImageView()
    var alarmButton = UIButton()
    var messageButton = UIButton()
    
    var scrollView = UIScrollView()
    var innerView = UIView()
    
    var searchView = UIView()
    var searchImageView = UIImageView()
    var searchLabel = UILabel()
    var userInfoLabel = UILabel()
    var mbtiInfoLabel = UILabel()
    var mbtiImageView = UIImageView()
    
    var lineView = UIView()
    var balanceGameLabel = UILabel()
    var goBalanceGameButton = UIButton()
    
    var noBalanceGameDataView = UIView()
    var noBalanceGameImageView = UIImageView()
    var noBalanceGameLabelImageView = UIImageView()
    
    var balanceGameView = UIView()
    var balaceGameTitleLabel = UILabel()
    var balanceGameTimeLabel = UILabel()
    var agreeButton = UIButton()
    var agreeCounts = UILabel()
    var disagreeButton = UIButton()
    var disagreeCounts = UILabel()
    var agreeImageView = UIImageView()
    var disagreeImageView = UIImageView()
    
    let lineView2 = UIView()
    var communityLabel = UILabel()
    
    var bannerButton = UIButton()
    var balanceGameDataStatus : balanceGameDataStatus = .yesData

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true

        layout()
        attribute()
        
        if balanceGameDataStatus == .noData {
            balanceGameView.isHidden = true
            noBalanceGameDataView.isHidden = false
        } else {
            balanceGameView.isHidden = false
            noBalanceGameDataView.isHidden = true
        }
    }
}

extension HomeViewController {
    @objc func didTapAlaramButton() {
        let nextVC = AlertViewController()
        nextVC.alertStatus = .yesAlert
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

private extension HomeViewController {
    func layout() {
        
        [mainLogoImageView,
         alarmButton,
         messageButton,
         scrollView,
         ].forEach {
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
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(30.0)
//            $0.bottom.equalTo(safeArea)
        }
        
        scrollViewLayout()
        searchBarLayout()
        balanceGameViewLayout()
        noBalanceGameViewLayout()
    }
    
    func attribute() {
        mainLogoImageView.image = UIImage(named: "main_logo")
        messageButton.setImage(UIImage(named: "message"), for: .normal)
        alarmButton.setImage(UIImage(named: "ic_notification"), for: .normal)
        alarmButton.addTarget(self, action: #selector(didTapAlaramButton), for: .touchUpInside)

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
        
        mbtiImageView.image = UIImage(named: "main character")
        
        lineView.backgroundColor = .mainTintColor
        
        balanceGameLabel.text = "🔥HOT한 밸런스 게임! 당신의 선택은?"
        balanceGameLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        
        goBalanceGameButton.layer.cornerRadius = 18.0
        goBalanceGameButton.layer.borderWidth = 1.0
        goBalanceGameButton.layer.borderColor = UIColor.mainTintColor.cgColor
        goBalanceGameButton.setTitleColor(.mainTintColor, for: .normal)
        goBalanceGameButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        
        bannerButton.setImage(UIImage(named: "img_banner"), for: .normal)
        lineView2.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 233/255, alpha: 1.0)
        
        communityLabel.text = "💬 급상승 중인 파인더들의 수다"
        communityLabel.font = .systemFont(ofSize: 20.0, weight: .bold)
        communityLabel.textColor = UIColor(red: 44/255, green: 44/255, blue: 44/255, alpha: 1.0)
                
        searchBarAttribute()
        balanceGameAttribute()
        noBalanceGameViewAttribute()
    }
    
    func scrollViewLayout() {
        
        scrollView.addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        
        innerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(1000)
        }
        innerViewLayout()
    }
    
    func innerViewLayout() {
        
        [searchView,
        userInfoLabel,
        mbtiInfoLabel,
        mbtiImageView,
        lineView,
        balanceGameLabel,
        noBalanceGameDataView,
        balanceGameView,
        goBalanceGameButton,
        bannerButton,
         lineView2,
         communityLabel].forEach {
           self.innerView.addSubview($0)
       }
        
        
        searchView.snp.makeConstraints {
//            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(30.0)
            $0.top.equalTo(innerView)
            $0.leading.equalTo(innerView).inset(20.0)
            $0.centerX.equalTo(innerView)
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
            $0.trailing.equalTo(innerView).inset(20.0)
            $0.width.equalTo(155.0)
            $0.height.equalTo(140.0)
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(2.0)
            $0.top.equalTo(mbtiImageView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
        }
        
        balanceGameLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(53.0)
            $0.centerX.equalTo(innerView)
        }
        
        noBalanceGameDataView.snp.makeConstraints {
            $0.top.equalTo(balanceGameLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
        }
        
        balanceGameView.snp.makeConstraints {
            $0.top.equalTo(balanceGameLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
        }
        
        goBalanceGameButton.snp.makeConstraints {
            $0.top.equalTo(balanceGameLabel.snp.bottom).offset(255.0)
            $0.centerX.equalTo(innerView)
            $0.height.equalTo(34.0)
            $0.width.equalTo(180.0)
        }
        
        bannerButton.snp.makeConstraints {
            $0.top.equalTo(goBalanceGameButton.snp.bottom).offset(56.0)
            $0.leading.trailing.equalTo(innerView)
            $0.height.equalTo(100.0)
        }
        
        lineView2.snp.makeConstraints {
            $0.top.equalTo(bannerButton.snp.bottom).offset(36.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(10.0)
        }
        
        communityLabel.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp.bottom).offset(56.0)
            $0.leading.equalTo(innerView).inset(20.0)
        }
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
    func balanceGameViewLayout() {
        
        [balaceGameTitleLabel,
         balanceGameTimeLabel,
         agreeCounts,
         disagreeCounts].forEach {
            self.balanceGameView.addSubview($0)
        }
        
        [agreeButton,
         disagreeButton,
         agreeImageView,
         disagreeImageView].forEach {
            self.balanceGameView.addSubview($0)
        }
        
        balaceGameTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(balanceGameView.snp.top)
        }
        
        balanceGameTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(balaceGameTitleLabel.snp.bottom).offset(4.0)
        }
        let screenWidth = self.view.bounds.width
        
        agreeCounts.snp.makeConstraints {
            $0.top.equalTo(balanceGameTimeLabel.snp.bottom).offset(32.0)
            $0.trailing.equalToSuperview().inset(screenWidth/2+22.0)
            $0.height.equalTo(64.0)
        }
        
        disagreeCounts.snp.makeConstraints {
            $0.top.equalTo(balanceGameTimeLabel.snp.bottom).offset(32.0)
            $0.leading.equalToSuperview().inset(screenWidth/2+22.0)
            $0.height.equalTo(64.0)
        }
        
        agreeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(balanceGameTimeLabel.snp.bottom).offset(75.0)
            $0.trailing.equalToSuperview().inset(screenWidth/2+6)
            $0.height.equalTo(55.0)
        }
        
        disagreeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(agreeButton)
            $0.leading.equalToSuperview().inset(screenWidth/2+6)
            $0.height.equalTo(55.0)
        }
        
        agreeImageView.snp.makeConstraints {
            $0.bottom.equalTo(agreeButton.snp.top)
            $0.leading.equalTo(agreeButton)
        }
        
        disagreeImageView.snp.makeConstraints {
            $0.bottom.equalTo(disagreeButton.snp.top)
            $0.trailing.equalTo(disagreeButton)
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
        
        [agreeCounts,disagreeCounts].forEach {
            $0.font = .systemFont(ofSize: 44.0, weight: .bold)
            $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            $0.text = "33"
            $0.textAlignment = .center
        }
        
        agreeButton.setTitle("물론 가능!", for: .normal)
        disagreeButton.setTitle("절대 불가능", for: .normal)
        
        [agreeButton,disagreeButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.setTitleColor(UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0), for: .normal)
            $0.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        }
        
        agreeButton.contentHorizontalAlignment = .left
        disagreeButton.contentHorizontalAlignment = .right
        
        agreeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        disagreeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
        
        goBalanceGameButton.setTitle("의견 남기러 가기 > ", for: .normal)
        goBalanceGameButton.addTarget(self, action: #selector(didTapGoBalanceGameButton), for: .touchUpInside)
        
        [agreeImageView,disagreeImageView].forEach {
            $0.image = UIImage(named: "Frame 986295")
            $0.isHidden = true
        }
        
        isselected()
    }
    
    @objc func didTapGoBalanceGameButton() {
        print("didTapGoBalanceGameButton")
    }
    
    func isselected() {
        agreeImageView.isHidden = false
        //b 81 70 241
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        agreeButton.backgroundColor = selectedColor
        agreeButton.setTitleColor(.white, for: .normal)
    }
    
    func noBalanceGameViewLayout() {
        [noBalanceGameImageView,noBalanceGameLabelImageView].forEach {
            self.noBalanceGameDataView.addSubview($0)
        }
        
        noBalanceGameImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noBalanceGameDataView.snp.top).inset(4.0)
        }
        
        noBalanceGameLabelImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(noBalanceGameImageView.snp.bottom).offset(16.0)
        }
    }
    
    func noBalanceGameViewAttribute() {
        noBalanceGameImageView.image = UIImage(named: "main character grey_home")
        noBalanceGameLabelImageView.image = UIImage(named: "Group 986336")
        goBalanceGameButton.setTitle("토론 만들러 가기 > ", for: .normal)
    }
}

