//
//  AlertViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/06.
//

import UIKit
import SnapKit

enum AlertStatus {
    case noAlert
    case yesAlert
}

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var alertStatus: AlertStatus = .noAlert
    let tableViewModel : AlertTableViewModel = AlertTableViewModel()
    
    // Header 설정
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "backButton"), for: .normal)
        $0.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    private lazy var headerTitle = UILabel().then {
        $0.text = "소식"
        $0.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.textAlignment = .center
    }
    
    var noAlertView = UIView()
    var yesAlertView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        attribute()
    }
}

extension AlertViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier, for: indexPath) as? AlertTableViewCell else {
            print("오류 : tableview Cell을 찾을 수 없습니다. ")
            return UITableViewCell()
        }
        
        let data = tableViewModel.cells[indexPath.row]
        cell.setupCell(data: data)
        return cell
    }
    
}

private extension AlertViewController {
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

private extension AlertViewController {
    func layout() {
        [backButton,
         headerTitle].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        backButton.snp.makeConstraints {
            $0.height.width.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(safeArea.snp.top).inset(12.0)
        }
        
        headerTitle.snp.makeConstraints {
            $0.centerY.equalTo(backButton)
            $0.centerX.equalToSuperview()
        }
        
        if alertStatus == .noAlert {
            noAlertViewLayout()
        } else {
            yesAlertViewLayout()
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
    }
}

// 알림이 없는 경우 view
private extension AlertViewController {
    func noAlertViewLayout() {
        
        self.view.addSubview(noAlertView)
        
        noAlertView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerTitle.snp.bottom).offset(14.0)
        }
        
        let noAlertImageView = UIImageView()
        noAlertImageView.image = UIImage(named: "Group 986335")
        
        noAlertView.addSubview(noAlertImageView)
        
        noAlertImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(120.0)
        }
    }
}

// 알림이 있는 경우 view
private extension AlertViewController {
    func yesAlertViewLayout() {
        self.view.addSubview(yesAlertView)
        
        yesAlertView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerTitle.snp.bottom).offset(14.0)
        }
        
        let tableview = UITableView()
        
        yesAlertView.addSubview(tableview)
        
        tableview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableview.backgroundColor = .white
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.identifier)
    }
}
