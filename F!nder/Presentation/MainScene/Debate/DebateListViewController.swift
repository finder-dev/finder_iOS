//
//  DiscussViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import PanModal

enum DebateListViewStatus {
    case isEmpty // data 없음
    case hasData // data 있음
}

/*
 * 토론 목록들을 보여주는 view controller
 */
final class DebateListViewController: BaseViewController {

    let headerView = DebateListHeaderView()
    var addBarButton = UIBarButtonItem()
    var discussViewStatus : DebateListViewStatus? = .isEmpty
    
    let debateTableView = DebateTableView()
    let emptyDebateView = EmptyDebateListView()
    
    let debateNetwork = DebateAPI()
    var tableViewData = [debateContent]()
    var isLastPage = false
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        [headerView, emptyDebateView, debateTableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
    
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
        }
        
        emptyDebateView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        debateTableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "토론"
        addBarButton = UIBarButtonItem(image: UIImage(named: "plus"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(didTapAddButton))
        
        self.navigationItem.rightBarButtonItem = addBarButton
        
        if discussViewStatus == .isEmpty {
            emptyDebateView.isHidden = false
            debateTableView.isHidden = true
        } else {
            emptyDebateView.isHidden = true
            debateTableView.isHidden = false
        }
        
        debateTableView.delegate = self
        debateTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(" DiscussViewController - viewWillAppear")
        pageCount = 0
        tableViewData = []
        fetchData(state: "PROCEEDING", page: pageCount)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapProgressDebate), name: Notification.Name("blockUser"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didTapEndDebate), name: Notification.Name("reportUser"), object: nil)
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("blockUser"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reportUser"), object: nil)
    }
    
    @objc func didTapProgressDebate() {
        print("didTapProgressDebate")
        pageCount = 0
        tableViewData = []
//        categoryLabel.text = "불나게 진행중인 토론"
        fetchData(state: "PROCEEDING", page: pageCount)
    }
    
    @objc func didTapEndDebate() {
        print("didTapEndDebate")
//        categoryLabel.text = "아쉽게 마감한 토론"
        pageCount = 0
        tableViewData = []
        fetchData(state: "COMPLETE", page: pageCount)

    }
    
    func fetchData(state: String, page:Int) {
        
        debateNetwork.requestEveryDebateData(state: state, page: page) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 전체 토론 글 조회 ")

                    guard let response = response.response  else {
                        return
                    }
                    tableViewData.append(contentsOf: response.content)
                    isLastPage = response.last
                    pageCount += 1
                    print(response.content)
                    print("pageCount : \(pageCount)")
                    
                    DispatchQueue.main.async {
                        if tableViewData.isEmpty {
                            discussViewStatus = .isEmpty
                            debateTableView.isHidden = true
                        } else {
                            discussViewStatus = .hasData
                            debateTableView.isHidden = false
                            debateTableView.reloadData()
                            debateTableView.tableFooterView?.isHidden = true
                        }
                    }
                } else {
                    print("실패 : 토론 글 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}

// TableView Paging
extension DebateListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (debateTableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("fetch additional data")
            if !isLastPage {
                self.debateTableView.tableFooterView = createSpinnerFooter()
                self.fetchData(state: "PROCEEDING", page: pageCount)
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

// 토론 데이터가 있는 경우 tableView delegate, datasource
extension DebateListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebateTableViewCell.identifier, for: indexPath) as? DebateTableViewCell else {
            return UITableViewCell()
        }
        let data = tableViewData[indexPath.row].toEntity
        cell.setupCell(data:data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let debate = tableViewData[indexPath.row]
        print(debate.debateId)
        print(indexPath.row)
        let nextVC = DiscussDetailViewController()
        nextVC.debateID = debate.debateId
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

private extension DebateListViewController {
    
    @objc func didTapAddButton() {
        print("didTapAddButton")
        let nextVC = MakeDiscussViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @objc func didTapCategoryButton() {
        print("didTapCategoryButton")
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.titles = ["불나게 진행중인 토론","아쉽게 마감한 토론"]
        presentPanModal(bottomSheetVC)
    }
}
