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
    
    let headerView = HomeHeaderView()
    var scrollView = UIScrollView()
    var innerView = UIView()
    let searchView = SearchBarView()
    let userMBTIView = UserMBTIView()
    
    var lineView = UIView()
    var balanceGameLabel = FinderLabel(text: "🔥HOT한 밸런스 게임! 당신의 선택은?",
                                       font: .systemFont(ofSize: 20.0, weight: .bold),
                                       textColor: .black1,
                                       textAlignment: .center)
    
    let emptyDebateView = EmptyDebateView()
    let debateVoteView = DebateVoteView()
    var goBalanceGameButton = UIButton()
    
    let lineView2 = UIView()
    let tableView = UITableView()
    let communityLabel = FinderLabel(text: "💬 급상승 중인 파인더들의 수다",
                                     font: .systemFont(ofSize: 20.0, weight: .bold),
                                     textColor: .black1)
    
    var bannerButton = UIButton()
    
    var balanceGameDataStatus : balanceGameDataStatus = .noData
    var communityTableViewModel : HomeCommunityTableViewModel = HomeCommunityTableViewModel()
    var hotCommunityData = [HotCommunitySuccessResponse]()
    let debateNetwork = DebateAPI()
    let communityNetwork = CommunityAPI()
    var debateID :Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        setupUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true

        layout()
        attribute()
        
        if balanceGameDataStatus == .noData {
            debateVoteView.isHidden = true
            emptyDebateView.isHidden = false
            goBalanceGameButton.setTitle("토론 만들러 가기 > ", for: .normal)
        } else {
            debateVoteView.isHidden = false
            emptyDebateView.isHidden = true
            goBalanceGameButton.setTitle("의견 남기러 가기 > ", for: .normal)
        }
        
        let token = UserDefaultsData.accessToken
        print(token)
    }
}

extension HomeViewController {
    
    func setupUserData() {
        
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
        debateVoteView.setupData(data)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = hotCommunityData[indexPath.row]
        let nextVC = CommunityDetailViewController()
        nextVC.communityId = data.communityId
        self.navigationController?.pushViewController(nextVC, animated: true)
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
        
        [headerView, scrollView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(safeArea)
            $0.top.equalTo(headerView.snp.bottom).offset(24.0)
        }
        
        scrollViewLayout()
    }
    
    func attribute() {
      
        headerView.alarmButton.addTarget(self, action: #selector(didTapAlaramButton), for: .touchUpInside)

        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapSearchView))
        searchView.addGestureRecognizer(gesture)
        
        lineView.backgroundColor = .mainTintColor
        lineView2.backgroundColor = UIColor(red: 228/255, green: 229/255, blue: 233/255, alpha: 1.0)
        
        goBalanceGameButton.layer.cornerRadius = 18.0
        goBalanceGameButton.layer.borderWidth = 1.0
        goBalanceGameButton.layer.borderColor = UIColor.mainTintColor.cgColor
        goBalanceGameButton.setTitleColor(.mainTintColor, for: .normal)
        goBalanceGameButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        
        bannerButton.setImage(UIImage(named: "img_banner"), for: .normal)
        bannerButton.addTarget(self, action: #selector(didTapBannerButton), for: .touchUpInside)
        
        goBalanceGameButton.addTarget(self, action: #selector(didTapGoBalanceGameButton), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HomeCommunityTableViewCell.self, forCellReuseIdentifier: HomeCommunityTableViewCell.identifier)
    }
    
    func scrollViewLayout() {
        
        scrollView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(1180)
        }
                
        [searchView, userMBTIView, lineView, balanceGameLabel, emptyDebateView,
         debateVoteView, goBalanceGameButton,bannerButton, lineView2, communityLabel,
         tableView].forEach {
           self.innerView.addSubview($0)
       }
        
        searchView.snp.makeConstraints {
            $0.top.equalTo(innerView)
            $0.leading.equalTo(innerView).inset(20.0)
            $0.centerX.equalTo(innerView)
            $0.height.equalTo(54.0)
        }
        
        userMBTIView.snp.makeConstraints {
            $0.top.equalTo(searchView.snp.bottom).offset(8.0)
            $0.leading.trailing.equalToSuperview()
        }
    
        lineView.snp.makeConstraints {
            $0.height.equalTo(2.0)
            $0.top.equalTo(userMBTIView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
        }
        
        balanceGameLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(53.0)
            $0.centerX.equalTo(innerView)
        }
        
        emptyDebateView.snp.makeConstraints {
            $0.top.equalTo(balanceGameLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
        }
        
        debateVoteView.snp.makeConstraints {
            $0.top.equalTo(balanceGameLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
            $0.width.equalTo(innerView.snp.width)
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(communityLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func innerViewLayout() {
        
        
    }
}

private extension HomeViewController {
    
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
    
    @objc func didTapSearchView() {
        print("didtapSearchView")
//        let nextVC = SearchViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
//        self.presentCutomAlert(target: "tapSearch", title: "아직 공사 중!", message: "조금만 기다려주세요♥")
        self.showPopUp1(title: "아직 공사 중!",
                        message: "조금만 기다려주세요♥",
                        buttonText: "확인",
                        buttonAction: {})
    }
}
