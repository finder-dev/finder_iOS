//
//  CommunityViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit

enum CommunityDataStatus {
    case noData
    case yesData
}

class CommunityViewController: UIViewController {
    
    let headerLabel = UILabel()
    let latestButton = UIButton()
    let commentButton = UIButton()
    let tableView = UITableView()
    let writeButton = UIButton()
    
    
    var communityDataStatus : CommunityDataStatus = .noData

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupHeaderView()
        layout()
        attribute()
    }

}

private extension CommunityViewController {
    @objc func didTapWriteButton() {
        let nextVC = WriteCommunityViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

private extension CommunityViewController {
    func layout() {
        [latestButton,
         commentButton].forEach {
            self.view.addSubview($0)
        }
        
        if communityDataStatus == .noData {
            noDataView()
        } else {
            yesDataView()
        }
        
        self.view.addSubview(writeButton)
        
        writeButton.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(26.0)
            $0.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(9.0)
        }
        
    }
    
    func attribute() {
        writeButton.setImage(UIImage(named: "floating"), for: .normal)
        writeButton.addTarget(self, action: #selector(didTapWriteButton), for: .touchUpInside)
    }
    
    func setupHeaderView() {
        
        self.view.addSubview(headerLabel)
        let safeArea = self.view.safeAreaLayoutGuide
        headerLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
            $0.top.equalTo(safeArea)
        }
        
        headerLabel.text = "커뮤니티"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
    }
}

private extension CommunityViewController {
    func noDataView() {
        let noDataImageView = UIImageView()
        self.view.addSubview(noDataImageView)
        
        noDataImageView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(120.0)
            $0.centerX.equalToSuperview()
        }
        
        noDataImageView.image = UIImage(named: "Group 986337")
    }
    
    func yesDataView() {
        self.view.addSubview(tableView)
        
//        tableView.snp.makeConstraints {
//
//        }
    }
}
