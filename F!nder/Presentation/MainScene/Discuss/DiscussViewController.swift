//
//  DiscussViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import PanModal

enum DiscussViewStatus {
    case noData
    case yesData
}

/*
 * 토론 목록들을 보여주는 view controller
 */
class DiscussViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let headerView = UIView()
    let headerTitle = UILabel()
    let addButton = UIButton()
    let categoryButton = UIButton()
    let categoryLabel = UILabel()
    let characterImageview = UIImageView()
    let lineView = UIView()
    var discussViewStatus : DiscussViewStatus? = .yesData
    
    let tableView = UITableView()
    
    let debateNetwork = DebateAPI()
    var tableViewData = [debateContent]()
    var isLastPage = false
    var pageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true

        setupHeaderView()
        layout()
        attribute()
//        fetchData(state: "PROCEEDING", page: pageCount)
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
        categoryLabel.text = "불나게 진행중인 토론"
        fetchData(state: "PROCEEDING", page: pageCount)
    }
    
    @objc func didTapEndDebate() {
        print("didTapEndDebate")
        categoryLabel.text = "아쉽게 마감한 토론"
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
                            discussViewStatus = .noData
                            tableView.isHidden = true
                        } else {
                            discussViewStatus = .yesData
                            tableView.isHidden = false
                            tableView.reloadData()
                            tableView.tableFooterView?.isHidden = true
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
extension DiscussViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("fetch additional data")
            if !isLastPage {
                self.tableView.tableFooterView = createSpinnerFooter()
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
extension DiscussViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiscussTableViewCell.identifier, for: indexPath) as? DiscussTableViewCell else {
            return UITableViewCell()
        }
        let data = tableViewData[indexPath.row]
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

private extension DiscussViewController {
    
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


private extension DiscussViewController {
    func layout() {
        [headerView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(124.5)
        }
        
        if discussViewStatus == .noData {
            noDataViewLayout()
        } else {
            yesDataViewLayout()
        }
    }
    
    func attribute() {
        
    }

    func setupHeaderView() {
        [headerTitle,
         addButton,
         categoryLabel,
         categoryButton,
         characterImageview,
         lineView].forEach {
            self.headerView.addSubview($0)
        }
            
        headerTitle.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.0)
            $0.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.centerY.equalTo(headerTitle)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        characterImageview.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15.0)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(3.0)
        }
        
        categoryButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(17.5)
        }
        categoryLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryButton)
            $0.leading.equalTo(categoryButton.snp.trailing).offset(8.0)
        }
        
        headerTitle.text = "토론"
        headerTitle.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerTitle.textColor = .black1
        headerTitle.textAlignment = .center
        
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.isEnabled = true
        
        characterImageview.image = UIImage(named: "Frame 986295")
        
        categoryLabel.text = "불나게 진행중인 토론"
        categoryLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        categoryLabel.textColor = .black1
            
        categoryButton.setImage(UIImage(named: "btn_caretleft"), for: .normal)
        categoryButton.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        
        lineView.backgroundColor = .primary
    }
}

private extension DiscussViewController {
    func noDataViewLayout() {
        let noDataImageView = UIImageView()
        noDataImageView.image = UIImage(named: "noDiscuss")
        
        self.view.addSubview(noDataImageView)
        
        noDataImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(66.5)
            $0.centerX.equalToSuperview()
        }
    }
    
    func yesDataViewLayout() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom).offset(3.0)
        }
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscussTableViewCell.self, forCellReuseIdentifier: DiscussTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
}
