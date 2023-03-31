//
//  SavedViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift

final class SavedViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: Properties
    
    var tableViewData = [CommunityTableDTO]()
    var pageCount = 0
    var isLastPage = false
    var dataStatus: DataStatus = .isPresent
    let communityNetwork = CommunityAPI()
    
    // MARK: Views
    
    let noDataImageView = UIImageView()
    let tableView = CommunityTableView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageCount = 0
        tableViewData = []
        fetchData(page: pageCount)
    }
    
    override func addView() {
        
        [noDataImageView, tableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        noDataImageView.snp.makeConstraints {
            $0.width.equalTo(153.0)
            $0.height.equalTo(133.0)
            $0.top.equalTo(safeArea.snp.top).inset(120.0)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(safeArea.snp.bottom).offset(16.0)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "저장"
        
        if dataStatus == .isPresent {
            noDataImageView.isHidden = true
            tableView.isHidden = false
        } else {
            noDataImageView.isHidden = false
            tableView.isHidden = true
        }
        
        noDataImageView.image = UIImage(named: "noSavedData")
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// TODO: 서버 오픈시 추후 수정
extension SavedViewController {
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
                            dataStatus = .isEmpty
                            tableView.isHidden = true
                        } else {
                            dataStatus = .isPresent
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
        let nextVC = CommunityDetailViewController(viewModel: CommunityDetailViewModel(communityId: data.communityId))
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
