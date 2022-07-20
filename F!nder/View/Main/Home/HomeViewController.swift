//
//  HomeViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import SafariServices

/*
 * 메인 탭 바 진입 시 가장 먼저 보이는 홈 뷰 컨트롤러입니다.
 */

enum balanceGameDataStatus {
    case noData
    case yesData
}

enum discussDataStatus {
    case noData
    case yesData
}

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // 헤더 components
    var mainLogoImageView = UIImageView()
    var alarmButton = UIButton()
    var messageButton = UIButton()
    
    // 스크롤 components
    var scrollView = UIScrollView()
    var innerView = UIView()

    var searchView = UIView()
    var searchImageView = UIImageView()
    var searchLabel = UILabel()
    var userInfoLabel = UILabel()
    var addLabel = UILabel()
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
    let tableView = UITableView()
    var communityLabel = UILabel()
    
    var bannerButton = UIButton()
    var balanceGameDataStatus : balanceGameDataStatus = .yesData
    var communityTableViewModel : HomeCommunityTableViewModel = HomeCommunityTableViewModel()
    var hotCommunityData = [HotCommunitySuccessResponse]()
    
//    let userInfoNetwork = UserInfoAPI()
    let debateNetwork = DebateAPI()
    let communityNetwork = CommunityAPI()
    var debateID :Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserData()
    }

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
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            print("오류 : token 없음")
            return
        }
        
        print(token)
    }
}

extension HomeViewController {
    func setupUserData() {
        let userMBTI = UserDefaults.standard.string(forKey: "userMBTI")
        let userNickName = UserDefaults.standard.string(forKey: "userNickName")
        
        userInfoLabel.text = "\(userMBTI ?? "nil") \(userNickName ?? "nil")"
        
        debateNetwork.requestHotDebate { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 가장 많이 참여한 토론 조회")
                    print("response.response?.debateId : \(response.response?.debateId)")
                    print("debateID : \(debateID)")
                    guard let response = response.response else {
                        return
                    }

                    debateID = response.debateId
                    print("debateID : \(debateID)")
                    DispatchQueue.main.async {
                        setupDebateView(data: response)
                    }
                } else {
                    print("실패 : 가장 많이 참여한 토론 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
        
        communityNetwork.requestHotCommunity { [self] result  in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 댓글순 커뮤니티 글 조회")
                    DispatchQueue.main.async {
                        setupCommunityView(data: response.response)
                    }
                } else {
                    print("실패 : 댓글순 커뮤니티 글 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func setupDebateView(data: HotDebateSuccessResponse) {

        balaceGameTitleLabel.text = data.title
        balanceGameTimeLabel.text = data.deadline
        agreeCounts.text = "\(data.optionACount)"
        disagreeCounts.text = "\(data.optionBCount)"
        
        if data.join {
            if data.joinOption == "A" {
                IsselectedA()
            } else if data.joinOption == "B" {
                IsSelectedB()
            }
        }
        agreeButton.setTitle(data.optionA, for: .normal)
        disagreeButton.setTitle(data.optionB, for: .normal)
        goBalanceGameButton.setTitle("의견 남기러 가기 > ", for: .normal)
    }
    
    func setupCommunityView(data: [HotCommunitySuccessResponse]?) {
        guard let data = data else { return}
        self.hotCommunityData = data
        self.tableView.reloadData()
    }
}

extension HomeViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotCommunityData.count
//        return communityTableViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCommunityTableViewCell.identifier, for: indexPath) as? HomeCommunityTableViewCell else {
            print("오류 - Home : communityTableview cell을 찾을 수 없습니다.")
            return UITableViewCell()
        }
        
        let data = hotCommunityData[indexPath.row]
        cell.setupCell(data: data, index: indexPath.row + 1)
        return cell
    }
    
}

extension HomeViewController {
    @objc func didTapAlaramButton() {
        let nextVC = AlertViewController()
        nextVC.alertStatus = .yesAlert
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func didTapBannerButton() {
        guard let url = URL(string: "https://www.16personalities.com/ko") else {
            print("오류 - HomeViewController : 유효하지 않은 url ")
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
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
        communityTableViewLayout()
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
        addLabel.text = "님,"
        addLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        addLabel.textColor = .blackTextColor
        
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
        bannerButton.addTarget(self, action: #selector(didTapBannerButton), for: .touchUpInside)
        
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
            $0.height.equalTo(1180)
        }
        
        innerViewLayout()
    }
    
    func innerViewLayout() {
        
        [searchView,
        userInfoLabel,
         addLabel,
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
        
        addLabel.snp.makeConstraints {
            $0.leading.equalTo(userInfoLabel.snp.trailing)
            $0.bottom.equalTo(userInfoLabel)
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
        let buttonWidth = (screenWidth - (20*2 + 13))/2
        
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
//            $0.trailing.equalToSuperview().inset(screenWidth/2+6)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(55.0)
        }
        
        disagreeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(agreeButton)
            $0.width.equalTo(buttonWidth)
//            $0.leading.equalToSuperview().inset(screenWidth/2+6)
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
        balaceGameTitleLabel.text = "test"
        balaceGameTitleLabel.font = .systemFont(ofSize: 16.0, weight: .medium)
        balaceGameTitleLabel.textColor = .blackTextColor
        balaceGameTitleLabel.textAlignment = .center
        balaceGameTitleLabel.numberOfLines = 0
        
        balanceGameTimeLabel.text = "test"
        balanceGameTimeLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
        balanceGameTimeLabel.textColor = UIColor(red: 154/255, green: 154/255, blue: 154/255, alpha: 1.0)
        
        [agreeCounts,disagreeCounts].forEach {
            $0.font = .systemFont(ofSize: 44.0, weight: .bold)
            $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            $0.text = "test"
            $0.textAlignment = .center
        }
        
        agreeButton.setTitle("test", for: .normal)
        disagreeButton.setTitle("test", for: .normal)
        
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
    }
    
    @objc func didTapGoBalanceGameButton() {
        if balanceGameDataStatus == .noData {
            print("here1")
            // 토론 생성 view
            self.navigationController?.pushViewController(MakeDiscussViewController(), animated: true)
        } else {
            // 토론 자세히 보기 view
            let nextVC = DiscussDetailViewController()
            guard let debateID = self.debateID else {
                print("no debateID")
                self.navigationController?.pushViewController(nextVC, animated: true)
                return
            }
            nextVC.debateID = debateID
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func IsselectedA() {
        agreeImageView.isHidden = false
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        agreeButton.backgroundColor = selectedColor
        agreeButton.setTitleColor(.white, for: .normal)
    }
    
    func IsSelectedB() {
        disagreeImageView.isHidden = false
        let selectedColor = UIColor(red: 81/255, green: 70/255, blue: 241/255, alpha: 1.0)
        disagreeButton.backgroundColor = selectedColor
        disagreeButton.setTitleColor(.white, for: .normal)
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

private extension HomeViewController {
    func communityTableViewLayout() {
        self.innerView.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(communityLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeCommunityTableViewCell.self, forCellReuseIdentifier: HomeCommunityTableViewCell.identifier)
    }
}

