//
//  SavedViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
enum dataStatus {
    case noData
    case yesData
}
class SavedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let headerView = UIView()
    let tableView = UITableView()
    
    var tableViewData = [content]()
    var pageCount = 0
    var isLastPage = false
    var dataStatus : dataStatus = .yesData {
        didSet {
            layout()
        }
    }
    let communityNetwork = CommunityAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("saved : - viewDidLoad")
        self.view.backgroundColor = .white
//        fetchData(page: pageCount)
        layout()
        attribute()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageCount = 0
        tableViewData = []
        fetchData(page: pageCount)
        layout()
        attribute()
    }
    
    
    func fetchData(page:Int) {
        communityNetwork.requestSavedCommuityList(page: page) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 저장한 커뮤니티 글 조회 ")

                    guard let response = response.response  else {
                        return
                    }
                    tableViewData.append(contentsOf: response.content)
                    isLastPage = response.last
                    pageCount += 1
                    print(response.content)
                    print("requestSavedCommuityList pageCount : \(pageCount)")
                    DispatchQueue.main.async {
                        if tableViewData.isEmpty {
                            dataStatus = .noData
                            tableView.isHidden = true
                        } else {
                            dataStatus = .yesData
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
extension SavedViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("fetch additional data")
            if !isLastPage {
                self.tableView.tableFooterView = createSpinnerFooter()
                fetchData(page: pageCount)
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



// tableview delegate, datasource
extension SavedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier) as? CommunityTableViewCell else {
            return UITableViewCell()
        }
        
        let data = tableViewData[indexPath.row]
        cell.setupCellData(data:data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableViewData[indexPath.row]
        let nextVC = CommunityDetailViewController()
        nextVC.communityId = data.communityId
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

private extension SavedViewController {
    func layout() {
        setupHeaderView()
        if dataStatus == .yesData {
            yesDataView()
        } else {
            noDataView()
        }
    }
    
    func attribute() {
        
    }
}

private extension SavedViewController {
    func setupHeaderView() {
        self.view.addSubview(headerView)
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }

        let headerLabel = UILabel()
        headerView.addSubview(headerLabel)
        
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }

        headerLabel.text = "저장"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
    }
    
    func noDataView() {
        let noDataImageView = UIImageView()
        noDataImageView.image = UIImage(named: "noSavedData")
        
        self.view.addSubview(noDataImageView)
        
        noDataImageView.snp.makeConstraints {
            $0.width.equalTo(153.0)
            $0.height.equalTo(133.0)
            $0.top.equalTo(headerView.snp.bottom).offset(120.0)
            $0.centerX.equalToSuperview()
        }
    }
    
    func yesDataView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom).offset(16.0)
        }
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
    }
    
}
