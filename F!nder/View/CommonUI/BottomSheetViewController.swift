//
//  BottomSheetViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/25.
//

import UIKit
import SnapKit

class BottomSheetViewController: UIViewController {

    let tableView = UITableView()
    var titles: [String] = ["차단","신고","닫기"]
    var userId: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        
    }
}

// tableView Delegate, datasource
extension BottomSheetViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let data = titles[indexPath.row]
        
        cell.textLabel?.text = data
        cell.textLabel?.textAlignment = .left
        
        cell.textLabel?.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(32.0)
            $0.top.bottom.equalToSuperview().inset(15.5)
            $0.height.equalTo(23.0)
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 20.0)
        
        cell.textLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        cell.textLabel?.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 차단
        if indexPath.row == 0 {
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: Notification.Name("blockUser"),object: nil)
            // 신고
        } else if indexPath.row == 1 {
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: Notification.Name("reportUser"),object: nil)
        } else if indexPath.row == 2 {
            self.dismiss(animated: true)
        }
    }
}

extension BottomSheetViewController: AlertMessage2Delegate {
    
    func presentCutomAlert2VC(target:String,
                              title:String,
                              message:String,
                              leftButtonTitle:String,
                              rightButtonTitle:String) {
        let nextVC = AlertMessage2ViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.leftButtonTitle = leftButtonTitle
        nextVC.rightButtonTitle = rightButtonTitle
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    func leftButtonTapped(from: String) {
        
    }
    
    func rightButtonTapped(from: String) {
        
    }
    
}

private extension BottomSheetViewController {
    func layout() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
    }
}
