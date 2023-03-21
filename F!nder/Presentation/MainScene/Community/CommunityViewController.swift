//
//  CommunityViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift

enum CommunityDataStatus {
    case noData
    case yesData
}

/*
 * 커뮤니티 글 리스트 뷰컨트롤러입니다.
 */
final class CommunityViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let sortView = CommunitySortView()
    private let noDataImageView = UIImageView()
    private let tableView = CommunityTableView()
    private let writeButton = UIButton()
    
    var communityDataStatus : CommunityDataStatus = .yesData {
        didSet {
        }
    }
    var communityNetwork = CommunityAPI()
    
    var communityList = [content]()
    var tableViewData = [content]()

    var isLastPage = false
    var pageCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func addView() {
        super.addView()
        
        [sortView, tableView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [noDataImageView, writeButton].forEach {
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
    }
}

extension CommunityViewController: SelectMBTIViewControllerDelegate {
    func selectedMBTI(mbti: String) {
        sortView.mbtiLabel.text = mbti
        tableViewData = []
        pageCount = 0
        if mbti == "전체" {
            setupData(mbti: nil, orderBy: "CREATE_TIME", page: pageCount)
        } else {
            setupData(mbti: mbti, orderBy: "CREATE_TIME", page: pageCount)
        }
    }
}

// TableView Datasource, Delegate
extension CommunityViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier) as? CommunityTableViewCell else {
            return UITableViewCell()
        }
        let data = tableViewData[indexPath.row]
        cell.setupCellData(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableViewData[indexPath.row]
        let nextVC = CommunityDetailViewController()
        nextVC.communityId = data.communityId
        self.navigationController?.pushViewController(nextVC, animated: true)
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
                                    communityDataStatus = .noData
                                    tableView.isHidden = true
                                } else {
                                    communityDataStatus = .yesData
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
