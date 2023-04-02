//
//  SavedViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/04.
//

import UIKit
import SnapKit
import RxSwift

final class SavedViewController: BaseViewController {

    // MARK: Properties
    
    var viewModel: SavedViewModel?
    var tableViewData = [CommunityTableDTO]()
    var pageCount = 0
    var isLastPage = false
    let communityNetwork = CommunityAPI()
    
    // MARK: Views
    
    private let noDataImageView = UIImageView()
    private let tableView = CommunityTableView()
    
    // MARK: - Life Cycle
    
    init(viewModel: SavedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            $0.edges.equalTo(safeArea)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "저장"
        noDataImageView.image = UIImage(named: "noSavedData")
    }
    
    override func bindViewModel() {
        
        // MARK: Output
        
        self.viewModel?.output.communityTableViewDataSource
            .distinctUntilChanged()
            .filter({ [weak self] data in
                self?.noDataImageView.isHidden = !data.isEmpty
                self?.tableView.isHidden = data.isEmpty
                return true
            })
            .bind(to: tableView.rx.items(
                cellIdentifier: CommunityTableViewCell.identifier,
                cellType: CommunityTableViewCell.self)) { index, item, cell in
                cell.setupCellData(data: item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CommunityTableDTO.self)
            .subscribe(onNext: { [weak self] item in
                let nextVC = CommunityDetailViewController(viewModel: CommunityDetailViewModel(communityId: item.communityId))
                self?.navigationController?.pushViewController(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
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
                            tableView.isHidden = true
                        } else {
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
