//
//  HomeViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import SafariServices
import RxSwift
import RxCocoa

/*
 * 메인 탭 바 진입 시 가장 먼저 보이는 홈 뷰 컨트롤러입니다.
 */

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: HomeViewModel?
    let disposeBag = DisposeBag()
    var balanceGameDataStatus: DataStatus = .isPresent
    var hotCommunityData = [HotCommunitySuccessDTO]()
    let debateNetwork = DebateAPI()
    let communityNetwork = CommunityAPI()
    var debateID :Int?
    
    // MARK: - Views
    
    let headerView = HomeHeaderView()
    let scrollView = UIScrollView()
    let innerView = UIView()
    let searchView = SearchBarView()
    let userMBTIView = UserMBTIView()
    let barView1 = BarView(barHeight: 3.0, barColor: .primary)
    let balanceGameLabel = FinderLabel(text: "🔥HOT한 밸런스 게임! 당신의 선택은?",
                                       font: .systemFont(ofSize: 20.0, weight: .bold),
                                       textColor: .black1,
                                       textAlignment: .center)
    
    let emptyDebateView = EmptyDebateView()
    let debateVoteView = DebateVoteView(at: .home)
    let goBalanceGameButton = UIButton()
    let barView2 = BarView(barHeight: 10.0, barColor: .grey4)
    let tableView = UITableView()
    let communityLabel = FinderLabel(text: "💬 급상승 중인 파인더들의 수다",
                                     font: .systemFont(ofSize: 20.0, weight: .bold),
                                     textColor: .black1)
    
    let bannerButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        layout()
        attribute()
        bindViewModel()

    }
    
    func bindViewModel() {
        
        headerView.alarmButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let nextVC = AlertViewController()
                nextVC.alertStatus = .yesAlert
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        bannerButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let url = URL(string: "https://www.16personalities.com/ko") else {
                    print("오류 - HomeViewController : 유효하지 않은 url ")
                    return
                }
                
                let safariVC = SFSafariViewController(url: url)
                self?.present(safariVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        goBalanceGameButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                if self?.balanceGameDataStatus == .isEmpty {
                    // 토론 생성 view
                    self?.navigationController?.pushViewController(MakeDebateViewController(viewModel: MakeDebateViewModel()), animated: true)
                } else {
                    // 토론 자세히 보기 view
                    let nextVC = DebateDetailViewController(viewModel: DebateDetailViewModel())
                    // TODO : 서버 오픈되면 수정
                    self?.navigationController?.pushViewController(nextVC, animated: true)
//                    if let debateID = self?.debateID {
//                        nextVC.debateID = debateID
//                        self?.navigationController?.pushViewController(nextVC, animated: true)
//                    }
                }
            })
            .disposed(by: disposeBag)
        
        searchView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
//                let nextVC = SearchViewController()
//                self.navigationController?.pushViewController(nextVC, animated: true)
           
                self?.showPopUp1(title: "아직 공사 중!",
                                 message: "조금만 기다려주세요♥",
                                 buttonText: "확인",
                                 buttonAction: {})
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.output.hotCommunityTableViewDataSource
            .bind(to: tableView.rx.items(cellIdentifier: HomeCommunityTableViewCell.identifier, cellType: HomeCommunityTableViewCell.self)) { index, item, cell in
                cell.setupCell(data: item, index: index + 1)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HotCommunitySuccessDTO.self)
            .subscribe(onNext: { item in
                let nextVC = CommunityDetailViewController(viewModel: CommunityDetailViewModel(communityId: item.communityId))
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
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
                    guard let response = response.response else {
                        return
                    }

                    debateID = response.debateId
                    DispatchQueue.main.async {
                        setupDebateView(data: response)
                    }
                } else {
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
    
    func setupCommunityView(data: [HotCommunitySuccessDTO]?) {
        guard let data = data else { return}
        self.hotCommunityData = data
        self.tableView.reloadData()
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
        
        scrollView.addSubview(innerView)
        
        innerView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(1180)
        }
        
        [searchView, userMBTIView, barView1, balanceGameLabel, emptyDebateView,
         debateVoteView, goBalanceGameButton,bannerButton, barView2, communityLabel,
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
    
        barView1.snp.makeConstraints {
            $0.top.equalTo(userMBTIView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalTo(innerView)
        }
        
        balanceGameLabel.snp.makeConstraints {
            $0.top.equalTo(barView1.snp.bottom).offset(53.0)
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
        
        barView2.snp.makeConstraints {
            $0.top.equalTo(bannerButton.snp.bottom).offset(36.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        communityLabel.snp.makeConstraints {
            $0.top.equalTo(barView2.snp.bottom).offset(56.0)
            $0.leading.equalTo(innerView).inset(20.0)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(communityLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        
        if balanceGameDataStatus == .isEmpty {
            debateVoteView.isHidden = true
            emptyDebateView.isHidden = false
            goBalanceGameButton.setTitle("토론 만들러 가기 > ", for: .normal)
        } else {
            debateVoteView.isHidden = false
            emptyDebateView.isHidden = true
            goBalanceGameButton.setTitle("의견 남기러 가기 > ", for: .normal)
        }

        goBalanceGameButton.layer.cornerRadius = 18.0
        goBalanceGameButton.layer.borderWidth = 1.0
        goBalanceGameButton.layer.borderColor = UIColor.primary.cgColor
        goBalanceGameButton.setTitleColor(.primary, for: .normal)
        goBalanceGameButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        
        bannerButton.setImage(UIImage(named: "img_banner"), for: .normal)
        tableView.register(HomeCommunityTableViewCell.self,
                           forCellReuseIdentifier: HomeCommunityTableViewCell.identifier)
    }
}
