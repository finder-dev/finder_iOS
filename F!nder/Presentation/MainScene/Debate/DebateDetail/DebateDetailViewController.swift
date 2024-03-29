//
//  DiscussDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/14.
//

import UIKit
import SnapKit
import PanModal
import RxSwift
import RxCocoa

/*
 * 토론 상세 뷰 입니다.
 */
final class DebateDetailViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: DebateDetailViewModel?
    var debateID : Int?
    var writerID = -1
    let debateNetwork = DebateAPI()
    var answerID = -1
    var textFieldYValue = CGFloat(0)
    
    // MARK: - Views
    
    let spaceView = BarView(barHeight: 24.0, barColor: .white)
    let debateDetailView = DebateVoteView(at: .detail)
    var barView = BarView(barHeight: 10.0, barColor: .grey10)
    let commentTableView = CommentTableView()
    let reportButton = UIBarButtonItem(image: UIImage(named: "icon-siren-mono"),
                                         style: .plain,
                                         target: nil,
                                         action: nil)
    lazy var tableViewHeightConstraint = commentTableView.heightAnchor.constraint(equalToConstant: 200.0)
    // MARK: - Life Cycle
    
    init(viewModel: DebateDetailViewModel) {
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
        super.addView()
        
        [spaceView, debateDetailView, barView, commentTableView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
    
        tableViewHeightConstraint.isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = commentTableView.contentSize.height
    }
    
    override func setupView() {
        self.title = "토론"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = reportButton
        self.scrollView.contentInset.bottom = 70
        
        commentView.commentTextField.placeholder = "토론에 참여해보세요!"
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        reportButton.rx.tap
            .bind { [weak self] in
                let bottomSheetVC = BottomSheetViewController()
                bottomSheetVC.delegate = self?.viewModel
                self?.presentPanModal(bottomSheetVC)
            }
            .disposed(by: disposeBag)
        
        // MARK: Input
        
        debateDetailView.buttonA.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.optionAButtonTrigger.onNext(())
            }.disposed(by: disposeBag)
        
        debateDetailView.buttonB.rx.tap
            .throttle(.seconds(3), scheduler: MainScheduler.instance)
            .bind { [weak self] in
                self?.viewModel?.input.optionBButtonTrigger.onNext(())
            }.disposed(by: disposeBag)
        
        commentView.addCommentButton.rx.tap
            .bind { [weak self] in
                guard let comment = self?.commentView.commentTextField.text else { return }
                self?.viewModel?.input.addCommentTrigger.onNext(comment)
            }
            .disposed(by: disposeBag)
        
        
        // MARK: Output

        self.viewModel?.output.answerTableViewDataSource
            .bind(to: self.commentTableView.rx.items(
                cellIdentifier: CommentTableViewCell.identifier,
                cellType: CommentTableViewCell.self)) { [weak self] index, item, cell in
                    
                cell.setupCell(data: item)
                cell.delegate = self?.viewModel
            }
            .disposed(by: disposeBag)
        
        self.viewModel?.output.showBlockPopup
            .subscribe(onNext: { [weak self] userId in
                self?.showPopUp2(title: "해당 사용자를 차단하시겠습니까?",
                           message: "차단 시, 해당 사용자의 모든 글이 보이지 않습니다.",
                           leftButtonText: "취소", rightButtonText: "차단",
                           leftButtonAction: {}, rightButtonAction: { [weak self] in
                    self?.viewModel?.input.blockUserTrigger.onNext(userId)
                })
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.output.showReportPopup
            .subscribe(onNext: { [weak self] userId in
                
                self?.showPopUp2(title: "해당 사용자를 신고하시겠습니까?",
                           message: "허위 신고일 경우, 활동이 제한될 수 있으니 신중히 신고해주세요.",
                           leftButtonText: "취소", rightButtonText: "신고", leftButtonAction: {}, rightButtonAction: {
                    self?.viewModel?.input.reportUserTrigger.onNext(userId)
                })
            })
            .disposed(by: disposeBag)
        
        self.viewModel?.output.showDeleteCommentPopup
            .subscribe(onNext: { [weak self] commentId in
                self?.showPopUp2(title: "댓글을 삭제하시겠습니까?",
                           message: "",
                           leftButtonText: "네", rightButtonText: "아니오",
                           leftButtonAction: {}, rightButtonAction: {
                    self?.viewModel?.input.deleteCommentTrigger.onNext(commentId)
                })
            })
            .disposed(by: disposeBag)
    }
}

// API - Fetch Data
extension DebateDetailViewController {
    // 서버로 부터 데이터 받기
    func fetchDebateData(debateID: Int) {
        print("fetchDebateData")
        debateNetwork.requestDebateDetail(debateID: debateID) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 상세 조회")
                    guard let response = response.response else {
                        return
                    }
                    DispatchQueue.main.async {
                        self.fetchData(data: response)
                    }
                } else {
                    print("실패 : 토론 상세 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }

    // 받은 데이터 ui에 넣기
    func fetchData(data:DetailDebateResponseDTO.DetailDebateSuccessDTO) {
//
//        guard let commentDataList = data.answerHistDtos else {return}
//        self.commentDataList = commentDataList
//        self.writerID = data.writerId
//        tableView.reloadData()
    }
}

// Button tap actions
extension DebateDetailViewController {
    
    @objc func didTapAgreeButton() {
        print("didTapAgreeButton")
        debateNetwork.requestVoteDebate(debateID: debateID!, option: "A") { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 옵션 A 투표")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    if response.message == "detach success" {
                        DispatchQueue.main.async {
//                            agreeImageView.isHidden = true
//                            deSelectedButton(button: agreeButton, option: "A")
                        }
                    }
                    fetchDebateData(debateID: debateID!)

                } else {
                    print("실패 : 토론 옵션 A 투표")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    @objc func didTapDisAgreeButton() {
        print("didTapDisAgreeButton")
        debateNetwork.requestVoteDebate(debateID: debateID!, option: "B") { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 옵션 B 투표")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    if response.message == "detach success" {
                        DispatchQueue.main.async {
//                            disagreeImageView.isHidden = true
//                            deSelectedButton(button: disagreeButton, option: "B")
                        }
                    }
                    
                    fetchDebateData(debateID: debateID!)
                    
                } else {
                    print("실패 : 토론 옵션 B 투표")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}

private extension DebateDetailViewController {
    
    @objc func didTapTextFieldButton() {
        print("didTapTextFieldButton")
        guard let text = commentView.commentTextField.text else { return }
        debateNetwork.requestNewComment(debateID: debateID!, content: text) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 댓글 달기 ")
                    guard let response = response.response else {
                        return
                    }
                    fetchDebateData(debateID: debateID!)
                    print(response.debateAnswerId)
                } else {
                    print("실패 : 댓글 달기")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}


extension DebateDetailViewController {
    func reportDebate() {
        debateNetwork.reportDebate(debateId: debateID!) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 신고")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
//                        self.presentCutomAlert1VC(target: "successReport", title: "해당 사용자 신고 완료", message: "신고되었습니다.")
                    }
                } else {
                    print("실패 : 토론 신ㄱ")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func deleteDebateComment() {
        debateNetwork.requestDeleteDebateComment(answerId: self.answerID) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 댓글 삭제")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
//                        self.presentCutomAlert1VC(target: "DeletedDebateComment", title: "댓글 삭제 완료", message: "삭제되었습니다.")
                    }
                } else {
                    print("실패 : 토론 댓글 삭제")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func reportDebateComment() {
        debateNetwork.reportDebateComment(answerId: self.answerID) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 토론 댓글 신고")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
//                        self.presentCutomAlert1VC(target: "reportedDebateComment", title: "해당 사용자 신고 완료", message: "신고되었습니다.")
                    }
                } else {
                    print("실패 : 토론 댓글 신고")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func blockUser() {
        let userAPI = UserInfoAPI()

        userAPI.requestBlockUser(userID: self.writerID) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 사용자 차단")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
//                        self.presentCutomAlert1VC(target: "reportedDebateComment", title: "해당 사용자 차단 완료", message: "차단되었습니다.")
                    }
                } else {
                    print("실패 : 토론 댓글 신고")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
}

