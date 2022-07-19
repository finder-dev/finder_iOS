//
//  DiscussViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit

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
        fetchData()
    }
    
    
    func fetchData() {
        
        debateNetwork.requestEveryDebateData(state: "PROCEEDING", page: 0) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 전체 커뮤니티 글 조회 ")

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
                    print("실패 : 전체 커뮤니티 글 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
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
        headerTitle.textColor = .blackTextColor
        headerTitle.textAlignment = .center
        
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        addButton.isEnabled = true
        
        characterImageview.image = UIImage(named: "Frame 986295")
        
        categoryLabel.text = "불나게 진행중인 토론"
        categoryLabel.font = .systemFont(ofSize: 18.0, weight: .bold)
        categoryLabel.textColor = .blackTextColor
            
        categoryButton.setImage(UIImage(named: "btn_caretleft"), for: .normal)
        categoryButton.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        
        lineView.backgroundColor = .mainTintColor
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
        
        tableView.backgroundColor = UIColor(red: 233/255, green: 234/255, blue: 239/255, alpha: 1.0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscussTableViewCell.self, forCellReuseIdentifier: DiscussTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
}
