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
    let tableViewData = [content]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()
    }
}

// tableview delegate, datasource
extension SavedViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier) as? CommunityTableViewCell else {
            return UITableViewCell()
        }
        
        let data = tableViewData[indexPath.row]
        cell.setupCellData(data:data)
        return cell
    }
}

private extension SavedViewController {
    func layout() {
        setupHeaderView()
        yesDataView()
//        noDataView()
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
    }
    
}
