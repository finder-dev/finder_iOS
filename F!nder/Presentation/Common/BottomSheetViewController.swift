//
//  BottomSheetViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/25.
//

import UIKit
import SnapKit
import PanModal

protocol BottomSheetDelegate {
    func selectedIndex(idx: Int)
}

class BottomSheetViewController: UIViewController {

    let tableView = UITableView()
    var titles: [String] = ["차단","신고","닫기"]
    var delegate: BottomSheetDelegate?

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
        cell.selectionStyle = .none
        
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
        let idx = indexPath.row
        self.dismiss(animated: true)
        self.delegate?.selectedIndex(idx: idx)
    }
}

// MARK: PanModal Setting

extension BottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }

    var shortFormHeight: PanModalHeight {
        let height = tableView.contentSize.height
        return .contentHeight(height)
    }
    
    var longFormHeight: PanModalHeight {
        let height = tableView.contentSize.height
        return .contentHeight(height)
    }
    
    var showDragIndicator: Bool {
        return false
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
        tableView.isScrollEnabled = false
    }
}
