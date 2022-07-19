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

/*
 * 커뮤니티 글 리스트 뷰컨트롤러입니다.
 */
class CommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectMBTIViewControllerDelegate {

    let headerView = UIView()
    let headerLine = UIView()
    let headerLabel = UILabel()
    let selectMBTIButton = UIButton()
    var selectedMBTILabel = UILabel()
    let mbtiLabelLine = UIView()
    let latestButton = UIButton()
    let commentButton = UIButton()
    let tableView = UITableView()
    let writeButton = UIButton()

    var totalTableRows = 15
    
    var communityDataStatus : CommunityDataStatus = .yesData
    var communityNetwork = CommunityAPI()
    
    var communityList = [content]()
    var tableViewData = [content]()
    
    var latestButtonIsSelected = true
    var commentButtonIsSelected = false
    
    var isLastPage = false
    var pageCount = 0

//    var isPaging: Bool = false // 현재 페이징 중인지 체크하는 flag

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupHeaderView()
        layout()
        addWriteButton()
        latestButton.setTitleColor(.blackTextColor, for: .normal)
        setupData(mbti: nil, orderBy: "CREATE_TIME", page: pageCount)
    }
 
    
    func sendValue(value: String) {
        selectedMBTILabel.text = value
    }
    
    
    func setupData(mbti:String?,
                   orderBy: String,
                   page: Int) {
        
        self.communityNetwork.requestEveryCommuityData(mbti: mbti,
                                                       orderBy: orderBy,
                                                       page: page) { [self] result in
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
                                tableView.reloadData()
                                tableView.tableFooterView?.isHidden = true
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
extension CommunityViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            print("fetch additional data")
            if !isLastPage {
                self.tableView.tableFooterView = createSpinnerFooter()
                setupData(mbti: nil, orderBy: "CREATE_TIME", page: pageCount)
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



// TableView Datasource, Delegate
extension CommunityViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommunityTableViewCell.identifier) as? CommunityTableViewCell else {
            return UITableViewCell()
        }
        let data = tableViewData[indexPath.row]
        cell.setupCellData(data: data)
        return cell
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
        let safeArea = self.view.safeAreaLayoutGuide
        
        [headerView,writeButton].forEach {
            self.view.addSubview($0)
        }
        
        if communityDataStatus == .noData {
            noDataView()
        } else {
            yesDataView()
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(98.5)
        }
    }
    
    func addWriteButton() {
        let safeArea = self.view.safeAreaLayoutGuide
        self.view.addSubview(writeButton)
        writeButton.snp.makeConstraints {
            $0.bottom.equalTo(safeArea).inset(26.0)
            $0.trailing.equalTo(safeArea).inset(9.0)
            
            writeButton.setImage(UIImage(named: "floating"), for: .normal)
            writeButton.addTarget(self, action: #selector(didTapWriteButton), for: .touchUpInside)
        }
        
    }
    
    func setupHeaderView() {
        
        [headerLine,
         headerLabel,
         selectMBTIButton,
         selectedMBTILabel,
         mbtiLabelLine,
         latestButton,
         commentButton].forEach {
            self.headerView.addSubview($0)
        }
                
        headerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(14.0)
        }
        
        headerLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.height.equalTo(1.0)
        }
        
        selectMBTIButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(3.5)
        }
        
        selectedMBTILabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(68.0)
            $0.bottom.equalToSuperview().inset(10.5)
//            $0.width.equalTo(30.0)
        }
        
        mbtiLabelLine.snp.makeConstraints {
            $0.leading.trailing.equalTo(selectedMBTILabel)
            $0.height.equalTo(3.0)
            $0.bottom.equalToSuperview()
        }
        
        commentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview().inset(7.5)
        }
        
        latestButton.snp.makeConstraints {
            $0.trailing.equalTo(commentButton.snp.leading).offset(-7.0)
            $0.bottom.equalTo(commentButton)
        }
        
        headerLabel.text = "커뮤니티"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
        
        headerLine.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        latestButton.setTitle(" • 최신순", for: .normal)
        // 188 188 188
        let unabledColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
        latestButton.setTitleColor(unabledColor, for: .normal)
        commentButton.setTitle(" • 댓글순", for: .normal)
        commentButton.setTitleColor(unabledColor, for: .normal)
        selectMBTIButton.setImage(UIImage(named: "btn_caretleft"), for: .normal)
        selectMBTIButton.addTarget(self, action: #selector(didTapSelectMBTIButton), for: .touchUpInside)
        
        [latestButton,commentButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .regular)
        }
        
        selectedMBTILabel.text = "전체"
        selectedMBTILabel.font = .systemFont(ofSize: 14.0, weight: .medium)
        selectedMBTILabel.textColor = .mainTintColor
        selectedMBTILabel.textAlignment = .center
        
        mbtiLabelLine.backgroundColor = .mainTintColor
        //"backButton"
    }
    
    @objc func didTapSelectMBTIButton() {
        print(" didTapSelectMBTIButton")
        let nextVC = SelectMBTIViewController()
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
//        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

private extension CommunityViewController {
    func noDataView() {
        let noDataImageView = UIImageView()
        self.view.addSubview(noDataImageView)
        
        noDataImageView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(67.5)
            $0.centerX.equalToSuperview()
        }
        
        noDataImageView.image = UIImage(named: "Group 986337")
    }
    
    func yesDataView() {
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: CommunityTableViewCell.identifier)
    }
}
