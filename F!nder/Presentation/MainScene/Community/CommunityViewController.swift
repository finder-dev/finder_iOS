//
//  CommunityViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift

/*
 * 커뮤니티 글 리스트 뷰컨트롤러입니다.
 */
final class CommunityViewController: BaseViewController {

    // MARK: - Properties
    
    var viewModel: CommunityViewModel?
    var communityDataStatus: DataStatus = .isPresent
    var communityNetwork = CommunityAPI()
    var communityList = [CommunityTableDTO]()
    var tableViewData = [CommunityTableDTO]()
    var isLastPage = false
    var pageCount = 0

    // MARK: - Views
    
    private let sortView = CommunitySortView()
    private let noDataImageView = UIImageView()
    private let tableView = CommunityTableView()
    private let writeButton = UIButton()
    
    // MARK: - Life Cycle
    
    init(viewModel: CommunityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func addView() {
        super.addView()
        
        [sortView, tableView, noDataImageView, writeButton].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        writeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(26.0)
            $0.trailing.equalTo(safeArea).inset(9.0)
        }
        
        sortView.snp.makeConstraints {
            $0.top.equalTo(safeArea)
            $0.leading.trailing.equalToSuperview()
        }
 
        tableView.snp.makeConstraints {
            $0.top.equalTo(sortView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        noDataImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(120)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func setupView() {
        self.title = "커뮤니티"
        self.view.backgroundColor = .white
        
        writeButton.setImage(UIImage(named: "floating"), for: .normal)
        noDataImageView.image = UIImage(named: "Group 986337")
        noDataImageView.isHidden = true
    }
    
    override func bindViewModel() {
        
        writeButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let nextVC = WriteCommunityViewController()
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        sortView.caretButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                let nextVC = SelectMBTIViewController()
                nextVC.delegate = self
                nextVC.modalPresentationStyle = .overFullScreen
                self?.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CommunityTableDTO.self)
            .subscribe(onNext: { [weak self] model in
                let nextVC = CommunityDetailViewController()
                nextVC.communityId = model.communityId
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        // MARK: Input
        
        sortView.latestButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.sortButtonTrigger.onNext("CREATE_TIME")
            }
            .disposed(by: disposeBag)
        
        sortView.commentButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.sortButtonTrigger.onNext("ANSWER_COUNT")
            }
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        self.viewModel?.output.communityTableViewDataSource
            .bind(to: tableView.rx.items(cellIdentifier: CommunityTableViewCell.identifier, cellType: CommunityTableViewCell.self)) { index, item, cell in
                cell.setupCellData(data: item)
            }
            .disposed(by: disposeBag)
    }
}

extension CommunityViewController: SelectMBTIViewControllerDelegate {
    func selectedMBTI(mbti: String) {
        sortView.mbtiLabel.text = mbti
        self.viewModel?.input.mbtiTrigger.onNext(mbti)
        
//        tableViewData = []
//        pageCount = 0
//        if mbti == "전체" {
//            setupData(mbti: nil, orderBy: "CREATE_TIME", page: pageCount)
//        } else {
//            setupData(mbti: mbti, orderBy: "CREATE_TIME", page: pageCount)
//        }
    }
}

// TODO: 추후 수정할 네트워크 로직
private extension CommunityViewController {
    
    func setupData(mbti:String?,
                   orderBy: String,
                   page: Int) {
        
        self.communityNetwork.requestEveryCommuityData(mbti: mbti,
                                                       orderBy: orderBy,
                                                       page: page) { [self] result in
                    switch result {
                    case let .success(response) :
                        if response.success {
                            print("성공 : 전체 커뮤니티 글 조회 ")

                            guard let response = response.response  else {
                                return
                            }
                            isLastPage = response.last
                            pageCount += 1
                            tableViewData.append(contentsOf: response.content)

                            print(response.content)
                            print("pageCount : \(pageCount)")
                            DispatchQueue.main.async {
                                if tableViewData.isEmpty {
                                    communityDataStatus = .isEmpty
                                    tableView.isHidden = true
                                } else {
                                    communityDataStatus = .isPresent
                                    tableView.isHidden = false
                                    tableView.reloadData()
                                    tableView.tableFooterView?.isHidden = true
                                }
                            }
                        } else {
                            print("실패 : 전체 커뮤니티 글 조회")
                            print(response.errorResponse?.errorMessages)
                        }
                    case .failure(_):
                        print("오류")
                    }
                }
            }
}

// TableView Paging
extension CommunityViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("fetch additional data")
            if !isLastPage {
                self.tableView.tableFooterView = createSpinnerFooter()
                setupData(mbti: nil, orderBy: "CREATE_TIME", page: pageCount)
            } else {
                print("This is last page")
                return
            }
        }
    }
    
    private func createSpinnerFooter() -> UIView {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
            
            let spinner = UIActivityIndicatorView()
            spinner.center = footerView.center
            footerView.addSubview(spinner)
            spinner.startAnimating()
            
            return footerView
        }
}
