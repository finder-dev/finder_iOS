//
//  CommunityDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import UIKit
import SnapKit
import RxSwift

/*
 * 커뮤니티 상세 보기 뷰
 */
final class CommunityDetailViewController: BaseViewController {
    
    // MARK: - Properties
    
    var viewModel: CommunityDetailViewModel?
    var communityId : Int?
    var communityUserId :Int?
    var commentDataList = [AnswerDTO]()
    let communityNetwork = CommunityAPI()
    var answerID = -1
    var writerID = -1
    var likeCount = -1
    lazy var tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 200.0)
    
    // MARK: - Views
    
    let saveButton = UIButton(type: .custom)
    let reportButton = UIButton(type: .custom)
    let communityDetailView = CommunityDetailView()
    let tableView = CommentTableView()

    // MARK: - Life Cycle
    
    init(viewModel: CommunityDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let communityId = communityId else {
            return
        }
        print("communityId : \(communityId)")
        fetchCommunityData(communityId: communityId)
    }
    
    override func addView() {
        super.addView()
        
        [communityDetailView, tableView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
    
        tableViewHeightConstraint.isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        tableViewHeightConstraint.constant = tableView.contentSize.height
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "커뮤니티"
        commentView.commentTextField.placeholder = "따뜻한 댓글을 남겨주세요!"

        reportButton.setImage(UIImage(named: "icon-dots"), for: [])
        reportButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        saveButton.setImage(UIImage(named: "Frame 986353"), for: [])
        saveButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)

        let rightBarButton1 = UIBarButtonItem(customView: reportButton)
        let rightBarButton2 = UIBarButtonItem(customView: saveButton)

        self.navigationItem.rightBarButtonItems = [rightBarButton1,rightBarButton2]
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        // MARK: Input
        
        reportButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let userId = UserDefaultsData.userId
                
                if userId == self?.communityUserId {
                    self?.showPopUp2(title: "글을 삭제하시겠습니까?",
                               message: "",
                               leftButtonText: "네", rightButtonText: "아니요",
                               leftButtonAction: { self?.deleteCommunityPost() }, rightButtonAction: { })
                    
                } else {
                    let bottomSheetVC = BottomSheetViewController()
                    bottomSheetVC.delegate = self?.viewModel
                    self?.presentPanModal(bottomSheetVC)
                }
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind { [weak self] in
                self?.viewModel?.input.saveButtonTrigger.onNext(())
            }
            .disposed(by: disposeBag)

        communityDetailView.recommendButtonIsSelected
            .asObservable()
            .subscribe(onNext: { [weak self] isSelected in
                self?.viewModel?.input.recommendButtonTrigger.onNext(isSelected)
            })
            .disposed(by: disposeBag)
        
        commentRelay
            .asObservable()
            .subscribe(onNext: { [weak self] comment in
                self?.viewModel?.input.addCommentTrigger.onNext(comment)
            })
            .disposed(by: disposeBag)
        
        // MARK: Output
        
        self.viewModel?.output.commentTableViewDataSource
            .bind(to: tableView.rx.items(
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
    }
}

// TODO: 서버 오픈되면 수정
extension CommunityDetailViewController {
    func fetchCommunityData(communityId:Int) {
        communityNetwork.requestCommunityDetail(communityID: communityId) { result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 상세 조회 ")

                    guard let response = response.response  else {
                        return
                    }

                    print(response)
                    DispatchQueue.main.async {
//                        self.addData(data: response)
                    }
                } else {
                    print("실패 : 커뮤니티 상세 조회")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    /*
    func addData(data: DetailCommunitySuccessDTO) {
        mbtiCategoryLabel.text = data.communityMBTI
        timeLabel.text = data.createTime
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
        titleLabel.text = data.communityTitle
        contentLabel.text = data.communityContent
//        commentCountLabel.text = "댓글 \(data.answerCount)"
        thumbsUpButton.setTitle(" 추천 \(data.likeCount)", for: .normal)
        if !data.isQuestion {
            questionImageView.isHidden = true
        }
        
        if data.saveUser {
            saveButton.setImage(UIImage(named: "saved2"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        }
        
        if data.likeUser {
            likeButton()
            
        } else {
            disLikeButton()
        }
         
        guard let communityData = data.answerHistDtos else {
            return
        }
        
        self.commentDataList = communityData
        self.communityUserId = data.userId
        self.writerID = data.userId
        self.likeCount = data.likeCount
        tableView.reloadData()
    }
    */
}

// button events
extension CommunityDetailViewController {
    @objc func didTapTextFieldButton() {
        print("didTapTextFieldButton")
        guard let text = commentView.commentTextField.text else { return }
        
        communityNetwork.requestNewComment(communityId: communityId!, content: text) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 댓글 달기 ")
                    guard let response = response.response else {
                        return
                    }
                    fetchCommunityData(communityId: communityId!)
                    print(response.communityAnswerId)
                } else {
                    print("실패 : 댓글 달기")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    @objc func blockDebateUser() {
        showPopUp2(title: "해당 사용자를 차단하시겠습니까?",
                   message:  "차단 시, 해당 사용자의 모든 글이 보이지 않습니다.",
                   leftButtonText: "취소", rightButtonText: "차단",
                   leftButtonAction: { }, rightButtonAction: { self.blockUser()})
    }
    
    @objc func reportDebateUser() {
        showPopUp2(title: "해당 사용자를 신고하시겠습니까?",
                   message:  "허위 신고일 경우, 활동이 제한될 수 있으니\n신중히 신고해주세요.",
                   leftButtonText: "취소", rightButtonText: "신고",
                   leftButtonAction: { }, rightButtonAction: { self.reportCommunityPost()})
    }
    
    @objc func didTapSaveButton() {
        print("didTapSaveButton")
        
        communityNetwork.requestSave(communityID: communityId!) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 글 저장 ")

                    guard let response = response.response  else {
                        return
                    }
                    if response.message == "save success" {
                        DispatchQueue.main.async {
                            saveButton.setImage(UIImage(named: "saved2"), for: .normal)
                            navigationItem.rightBarButtonItems?[0].tintColor = .primary
                        }
                    } else {
                        DispatchQueue.main.async {
                            saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
                        }
                    }
                    print(response.message)
                    
                } else {
                    print("실패 : 커뮤니티 글 저장")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
}

extension CommunityDetailViewController {
    
    @objc func didTapThumbsUpButton() {
        print("didTapThumbsUpButton")
        
        communityNetwork.requestCommunityLike(communityId: communityId!) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 좋아요 ")

                    guard let response = response.response  else {
                        return
                    }
                    if response.message == "add success" {
                        DispatchQueue.main.async {
//                            self.likeButton()
                            likeCount += 1
//                            thumbsUpButton.setTitle(" 추천 \(likeCount)", for: .normal)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
//                            self.disLikeButton()
                            likeCount -= 1
//                            thumbsUpButton.setTitle(" 추천 \(likeCount)", for: .normal)
                        }
                        
                    }
                    print(response.message)
                    
                } else {
                    print("실패 : 커뮤니티 좋아요")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }

}


extension CommunityDetailViewController {
    
    func deleteCommunityPost() {
        self.communityNetwork.requestDeleteCommunity(communityId: communityId!) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 글 삭제")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
                        self.showPopUp1(title: "글 삭제 완료",
                                        message: "삭제되었습니다.",
                                        buttonText: "확인",
                                        buttonAction: { })
                    }
                } else {
                    print("실패 : 커뮤니티 글 삭제")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func reportCommunityPost() {
        self.communityNetwork.reportCommunity(communityId: communityId!) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 글 신고")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
                        self.showPopUp1(title: "해당 사용자 삭제 완료",
                                        message: "신고되었습니다.",
                                        buttonText: "확인",
                                        buttonAction: { })
                    }
                } else {
                    print("실패 : 커뮤니티 글 신고")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func reportCommunityComment() {
        communityNetwork.reportCommunityComment(answerId: self.answerID) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 댓글 신고")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    DispatchQueue.main.async {
                        self.showPopUp1(title: "해당 사용자 삭제 완료",
                                        message: "신고되었습니다.",
                                        buttonText: "확인",
                                        buttonAction: { })
                    }
                } else {
                    print("실패 : 커뮤니티 댓글 삭제")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func deleteCommunityComment() {
        communityNetwork.requestDeleteCommunityComment(answerId: self.answerID) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 커뮤니티 댓글 삭제")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                    self.showPopUp1(title: "댓글 삭제 완료",
                                    message: "삭제되었습니다.",
                                    buttonText: "확인",
                                    buttonAction: { })
                } else {
                    print("실패 : 커뮤니티 댓글 삭제")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
        }
    }
    
    func blockUser() {
        let userAPI = UserInfoAPI()

        userAPI.requestBlockUser(userID:self.writerID ) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 사용자 차단")
                    guard let response = response.response else {
                        return
                    }
                    print(response.message)
                   
                    DispatchQueue.main.async {
                        self.showPopUp1(title: "해당 사용자 차단 완료",
                                        message: "차단되었습니다.",
                                        buttonText: "확인",
                                        buttonAction: { })
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
