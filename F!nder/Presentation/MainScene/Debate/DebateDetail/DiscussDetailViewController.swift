//
//  DiscussDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/14.
//

import UIKit
import SnapKit
import SwiftUI
import PanModal

/*
 * 토론 상세 뷰 입니다.
 */
final class DiscussDetailViewController: BaseViewController, UITextFieldDelegate{
    
    // MARK: - Properties
    
    var commentDataList = [answerHistDtos]()
    var debateID : Int?
    var writerID = -1
    let debateNetwork = DebateAPI()
    var answerID = -1
    var textFieldYValue = CGFloat(0)
    
    // MARK: - Views
    
    let spaceView = BarView(barHeight: 24.0, barColor: .white)
    let debateDetailView = DebateVoteView(at: .detail)
    var barView = BarView(barHeight: 10.0, barColor: .grey10)
    var commentView = UIView()
    var commentTextField = UITextField()
    let addCommentButton = UIButton()
    var btnView = UIButton()
    let tableView = CommentTableView()
    let reportButton = UIBarButtonItem(image: UIImage(named: "icon-siren-mono"),
                                         style: .plain,
                                         target: nil,
                                         action: nil)
    lazy var constraint = commentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func addView() {
        super.addView()
        
        [spaceView, debateDetailView, barView, tableView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.view.addSubview(commentView)
        
        [commentTextField, addCommentButton].forEach {
            commentView.addSubview($0)
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        commentView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(78.0)
        }
        
        commentTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(42.0)
        }
        
        addCommentButton.snp.makeConstraints {
            $0.width.height.equalTo(34.0)
            $0.trailing.top.bottom.equalTo(commentTextField).inset(4.0)
        }
    }
    
    override func setupView() {
        self.title = "토론"
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.rightBarButtonItem = reportButton
        
        commentView.backgroundColor = .white
        commentView.layer.borderWidth = 1.0
        commentView.layer.borderColor = UIColor.grey11.cgColor
        
        commentTextField.backgroundColor = .grey11
        commentTextField.placeholder = "토론에 참여해보세요!"
        commentTextField.layer.cornerRadius = 20.0
        commentTextField.addLeftPadding(padding: 16.0)
        
        addCommentButton.backgroundColor = .grey1
        addCommentButton.setImage(UIImage(named: "ic:baseline-arrow-forward") ?? UIImage(),
                                  for: .normal)
        addCommentButton.layer.cornerRadius = 17.0
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    // 옵저버 등록
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(reportDebateUser), name: Notification.Name("reportUser"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(blockDebateUser), name: Notification.Name("blockUser"), object: nil)
    }
    
    // 옵저버 해제
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("blockUser"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reportUser"), object: nil)
        
        super.viewWillDisappear(animated)
    }
}

// API - Fetch Data
extension DiscussDetailViewController {
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
    func fetchData(data:DetailDebateSuccessResponse) {
//
//        guard let commentDataList = data.answerHistDtos else {return}
//        self.commentDataList = commentDataList
//        self.writerID = data.writerId
//        tableView.reloadData()
    }
}

// 댓글 Tableview delegate, datasource
extension DiscussDetailViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DebateCommentTableViewCell.identifier, for: indexPath) as? DebateCommentTableViewCell else {
            print("오류 : tableview Cell을 찾을 수 없습니다. ")
            return UITableViewCell()
        }
        
        if !commentDataList.isEmpty {
            print("!commentDataList.isEmpty")
            let data = commentDataList[indexPath.row]
            cell.setupCell(data: data)
            cell.delegate = self
        }
        
        return cell
    }
}

// 댓글에서 점버튼 눌렀을 때
extension DiscussDetailViewController: CommentCellDelegate {
    
    func report(answerID: Int) {
        presentCutomAlert2VC(target: "reportComment",
                             title: "해당 사용자를 신고하시겠습니까?",
                             message: "허위 신고일 경우, 활동이 제한될 수 있으니 신중히 신고해주세요.",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "신고")
        self.answerID = answerID
       
    }
    
    func delete(answerID: Int) {
        presentCutomAlert2VC(target: "deleteComment",
                             title: "댓글을 삭제하시겠습니까?",
                             message: "",
                             leftButtonTitle: "네",
                             rightButtonTitle: "아니요")
        self.answerID = answerID
    }
    
}

// 댓글 TextField 이동
extension DiscussDetailViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
      }

      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          commentTextField.resignFirstResponder()
          return true
      }

//    @objc private func keyboardWillHide(_ notification: Notification) {
//        print("keyboardWillHide")
//        self.view.frame.origin.y = 0
//    }

    
//    @objc private func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            UIView.animate(withDuration: 0.3
//                           , animations: {
//
//                let keyboardHeight = keyboardRectangle.height
//                if self.view.frame.origin.y == 0 {
//                    let bottomSpace = self.view.frame.height - (self.textFieldView.frame.origin.y + self.textFieldView.frame.height)
//                    self.view.frame.origin.y -= keyboardHeight
//                }
//            })
//        }
//    }
}

// Button tap actions
extension DiscussDetailViewController {
    @objc func blockDebateUser() {
        print("===========blockDebateUser")
        presentCutomAlert2VC(target: "blockDebateUser",
                             title: "해당 사용자를 차단하시겠습니까?",
                             message: "차단 시, 해당 사용자의 모든 글이 보이지 않습니다.",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "차단")
    }
    
    @objc func reportDebateUser() {
        print("===========reportDebateUser")
        presentCutomAlert2VC(target: "reportButton",
                             title: "해당 사용자를 신고하시겠습니까?",
                             message: "허위 신고일 경우, 활동이 제한될 수 있으니 신중히 신고해주세요.",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "신고")
    }
    
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
    
    // 바텀 시트 보여주기
    @objc func didTapRightBarButton() {
        let bottomSheetVC = BottomSheetViewController()
        presentPanModal(bottomSheetVC)
    }
}

// 커스텀 AlertView Delegate
extension DiscussDetailViewController: AlertMessageDelegate, AlertMessage2Delegate {
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
    
    func presentCutomAlert1VC(target:String,
                              title:String,
                              message:String) {
        let nextVC = AlertMessageViewController()
        nextVC.titleLabelText = title
        nextVC.textLabelText = message
        nextVC.delegate = self
        nextVC.target = target
        nextVC.modalPresentationStyle = .overCurrentContext
        self.present(nextVC, animated: true)
    }
    
    func leftButtonTapped(from: String) {
        if from == "deleteComment" {
            print("댓글 삭제")
            deleteDebateComment()
        }
    }
    
    func rightButtonTapped(from: String) {
        if from == "reportButton" {
            // 토론 신고
            reportDebate()
        } else if from == "reportComment" {
            print("해당 댓글 사용자 신고 완료")
            reportDebateComment()
        } else if from == "blockDebateUser" {
            blockUser()
        }
    }

    func okButtonTapped(from: String) {
        if from == "DeletedDebateComment" || from == "reportedDebateComment" {
            self.navigationController?.popViewController(animated: true)
        }
    }

}

private extension DiscussDetailViewController {
    func layout() {
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(barView.snp.bottom)
            $0.bottom.equalTo(commentView.snp.top)
        }
        
        constraint.isActive = true
    }
    
    @objc func didTapTextFieldButton() {
        print("didTapTextFieldButton")
        guard let text = commentTextField.text else { return }
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


extension DiscussDetailViewController {
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
                        self.presentCutomAlert1VC(target: "successReport", title: "해당 사용자 신고 완료", message: "신고되었습니다.")
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
                        self.presentCutomAlert1VC(target: "DeletedDebateComment", title: "댓글 삭제 완료", message: "삭제되었습니다.")
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
                        self.presentCutomAlert1VC(target: "reportedDebateComment", title: "해당 사용자 신고 완료", message: "신고되었습니다.")
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
                        self.presentCutomAlert1VC(target: "reportedDebateComment", title: "해당 사용자 차단 완료", message: "차단되었습니다.")
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

