//
//  CommunityDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import UIKit
import SnapKit

/*
 * 커뮤니티 상세 보기 뷰
 */
class CommunityDetailViewController: UIViewController, UITextFieldDelegate{
    
    let saveButton = UIButton(type: .custom)
    let headerView = UIView()
    let questionImageView = UIImageView()
    let mbtiCategoryLabel = UILabel()
    let titleLabel = UILabel()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
//    let saveButton = UIButton()
    let thumbsUpButton = UIButton()
    let commentView = UIView()
    let commentImageView = UIImageView()
    let commentCountLabel = UILabel()
    
    let lineView = UIView()
    let contentLabel = UILabel()
    let lineView2 = UIView()
    let emptyView = UIView()
    var communityId : Int?
    var communityUserId :Int?
    
    var textFieldView = UIView()
    var commentTextField = UITextField()
    var btnView = UIButton()
    var textFieldYValue = CGFloat(0)
    let tableView = UITableView()
    var commentDataList = [AnswerDTO]()

    let communityNetwork = CommunityAPI()
    var answerID = -1
    var writerID = -1
    var likeCount = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        setupHeaderView()
        setupTableView()
        commentTextField.delegate = self
        guard let communityId = communityId else {
            return
        }
        print("communityId : \(communityId)")
        fetchCommunityData(communityId: communityId)
    }

    
    // 옵저버 등록
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reportDebateUser), name: Notification.Name("reportUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockDebateUser), name: Notification.Name("blockUser"), object: nil)
        setupNavigationAttribute()
    }
    
    func setupNavigationAttribute() {
        self.navigationController?.navigationBar.isHidden = false
        
        let reportButton = UIButton(type: .custom)
        reportButton.setImage(UIImage(named: "icon-dots"), for: [])
        reportButton.addTarget(self, action: #selector(didTapDotButton), for: .touchUpInside)
        reportButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        saveButton.setImage(UIImage(named: "Frame 986353"), for: [])
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        saveButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        let rightBarButton1 = UIBarButtonItem(customView: reportButton)
        let rightBarButton2 = UIBarButtonItem(customView: saveButton)
        
        self.navigationItem.rightBarButtonItems = [rightBarButton1,rightBarButton2]
        
        let backButton  = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .black1
        self.navigationItem.title = "커뮤니티"
    }
    
    // 옵저버 해제
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("blockUser"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reportUser"), object: nil)
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}

// API 통신
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
                        self.addData(data: response)
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
    
    func addData(data: DetailCommunitySuccessResponse) {
        mbtiCategoryLabel.text = data.communityMBTI
        timeLabel.text = data.createTime
        userMBTILabel.text = data.userMBTI
        userNameLabel.text = " • \(data.userNickname)"
        titleLabel.text = data.communityTitle
        contentLabel.text = data.communityContent
        commentCountLabel.text = "댓글 \(data.answerCount)"
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
    
    func likeButton() {
        thumbsUpButton.setImage(UIImage(named: "icon-thumb-up-mono"), for: .normal)
        thumbsUpButton.setTitleColor(.primary, for: .normal)
    }
    
    func disLikeButton() {
        thumbsUpButton.setImage(UIImage(named: "icon-thumb-up"), for: .normal)
        thumbsUpButton.setTitleColor(UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0), for: .normal)
    }
}

// TableView - delegate, datasource
extension CommunityDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        commentDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            print("오류 : tableview Cell을 찾을 수 없습니다. ")
            return UITableViewCell()
        }
        
        if !commentDataList.isEmpty {
            print("!commentDataList.isEmpty")
            let data = commentDataList[indexPath.row]
//            cell.setupCell(data: data)
            cell.delegate = self
        }
        
        return cell
    }
    
}

// cell의 닷 선택시 실행
extension CommunityDetailViewController: CommentCellDelegate  {
    func report(userID: Int) {
        
        presentCutomAlert2VC(target: "reportCommunityComment",
                             title: "해당 사용자를 신고하시겠습니까?",
                             message: "허위 신고일 경우, 활동이 제한될 수 있으니 신중히 신고해주세요.",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "신고")
        self.answerID = userID
    }
    
    func delete(commentID: Int) {
        presentCutomAlert2VC(target: "deleteCommunityComment",
                             title: "댓글을 삭제하시겠습니까?",
                             message: "",
                             leftButtonTitle: "네",
                             rightButtonTitle: "아니요")
        self.answerID = commentID
    }
}

extension CommunityDetailViewController {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          view.endEditing(true)
      }

      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          commentTextField.resignFirstResponder()
          return true
      }

    @objc private func keyboardWillHide(_ notification: Notification) {
        print("keyboardWillHide")
        self.view.frame.origin.y = 0
    }

    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.3
                           , animations: {
                
                let keyboardHeight = keyboardRectangle.height
                if self.view.frame.origin.y == 0 {
                    let bottomSpace = self.view.frame.height - (self.textFieldView.frame.origin.y + self.textFieldView.frame.height)
                    self.view.frame.origin.y -= keyboardHeight
                }
            })
        }
    }
}

// cumstom alert message VC
extension CommunityDetailViewController : AlertMessage2Delegate , AlertMessageDelegate{
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
        if from == "deletePost" {
            deleteCommunityPost()
        } else if from == "deleteCommunityComment" {
            deleteCommunityComment()
        }
    }
    
    func rightButtonTapped(from: String) {
        if from == "reportCommunityUser" {
            reportCommunityPost()
        } else if from == "reportCommunityComment" {
            reportCommunityComment()
        } else if from == "blockCommunityUser" {
            blockUser()
        }
    }
   
    func okButtonTapped(from: String) {
        if from == "didDeletePost" || from == "didReportCommunityUser" || from == "DeletedCommunityComment" || from == "didReportCommunityComment" {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// button events
extension CommunityDetailViewController {
    @objc func didTapTextFieldButton() {
        print("didTapTextFieldButton")
        guard let text = commentTextField.text else { return }
        
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
        print("===========blockCommunityUser")
        self.presentCutomAlert2VC(target: "blockCommunityUser",
                             title: "해당 사용자를 차단하시겠습니까?",
                             message: "차단 시, 해당 사용자의 모든 글이 보이지 않습니다.",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "차단")
    }
    
    @objc func reportDebateUser() {
        print("===========reportCommunityUser")
    
        self.presentCutomAlert2VC(target: "reportCommunityUser",
                                  title: "해당 사용자를 신고하시겠습니까?",
                                  message: "허위 신고일 경우, 활동이 제한될 수 있으니\n신중히 신고해주세요.",
                                  leftButtonTitle: "취소",
                                  rightButtonTitle: "신고")
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDotButton() {
        let userId = UserDefaultsData.userId
        
        if userId == communityUserId {
            DispatchQueue.main.async {
                self.presentCutomAlert2VC(target: "deletePost",
                                          title: "글을 삭제하시겠습니까?",
                                          message: "",
                                          leftButtonTitle: "네",
                                          rightButtonTitle: "아니요")
            }
            
        } else {
            let bottomSheetVC = BottomSheetViewController()
            presentPanModal(bottomSheetVC)
        }
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
    func layout() {
        
        [
         mbtiCategoryLabel,
         questionImageView,
         titleLabel,
         userMBTILabel,
         userNameLabel,
         timeLabel,
         lineView,
         contentLabel,
         lineView2,
         thumbsUpButton,
         commentView,
         emptyView,
         tableView,
         textFieldView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        mbtiCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(16.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.equalTo(43.0)
            $0.height.equalTo(30.0)
        }
        
        questionImageView.snp.makeConstraints {
            $0.centerY.equalTo(mbtiCategoryLabel)
            $0.leading.equalTo(mbtiCategoryLabel.snp.trailing).offset(8.0)
            $0.width.equalTo(47.0)
            $0.height.equalTo(34.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(mbtiCategoryLabel.snp.bottom).offset(20.0)
            $0.leading.equalTo(mbtiCategoryLabel)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(mbtiCategoryLabel)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(userMBTILabel)
            $0.leading.equalTo(userMBTILabel.snp.trailing)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(userMBTILabel)
        }
        
        lineView.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(userMBTILabel.snp.bottom).offset(20.0)
            $0.height.equalTo(1.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        lineView2.snp.makeConstraints {
            $0.trailing.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(contentLabel.snp.bottom).offset(31.5)
            $0.height.equalTo(1.0)
        }
        
        let buttonWidth = self.view.bounds.width/2 - 20.0
        thumbsUpButton.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp.bottom)
            $0.leading.equalTo(lineView2.snp.leading)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(56.0)
        }
        
        commentView.snp.makeConstraints {
            $0.top.equalTo(thumbsUpButton)
            $0.trailing.equalTo(lineView2)
            $0.height.equalTo(56.0)
            $0.width.equalTo(buttonWidth)
        }
        
        [commentImageView,commentCountLabel].forEach {
            commentView.addSubview($0)
        }
        
        let leadingSpacing = buttonWidth * 50.0 / 167.0
        
        commentImageView.snp.makeConstraints {
            $0.leading.equalTo(commentView).inset(leadingSpacing)
            $0.width.height.equalTo(24.0)
            $0.centerY.equalToSuperview()
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(commentImageView.snp.trailing).offset(4.0)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(thumbsUpButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(10.0)

        }
        
        textFieldView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
//            $0.bottom.equalTo(safeArea)
            $0.height.equalTo(78.0)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(emptyView.snp.bottom)
            $0.bottom.equalTo(textFieldView.snp.top)
        }
        
        tableView.backgroundColor = .white
            
        textFieldView.addSubview(commentTextField)
        
        commentTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(42.0)
        }
        
        emptyView.backgroundColor = UIColor(red: 233/255, green: 234/255, blue: 239/255, alpha: 1.0)
        textFieldView.backgroundColor = .white
        textFieldView.layer.borderWidth = 1.0
        textFieldView.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
        
         questionImageView.image = UIImage(named: "Group 986359")
         
         mbtiCategoryLabel.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
         mbtiCategoryLabel.layer.cornerRadius = 5.0
         mbtiCategoryLabel.textColor = .black1
         mbtiCategoryLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
         mbtiCategoryLabel.textAlignment = .center
        
        titleLabel.textColor = .black1
        titleLabel.font = .systemFont(ofSize: 18.0, weight: .medium)
        titleLabel.numberOfLines = 0
        
        contentLabel.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        contentLabel.font = .systemFont(ofSize: 14.0, weight: .regular)
        contentLabel.numberOfLines = 0

        [lineView,lineView2].forEach {
            $0.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        }

        [userMBTILabel,userNameLabel,timeLabel].forEach {
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
        }
        
        commentTextField.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        commentTextField.placeholder = "따뜻한 댓글을 남겨주세요!"
        commentTextField.layer.cornerRadius = 20.0//ic_baseline-arrow-forward
        commentTextField.addLeftPadding(padding: 16.0)
        btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 34.0, height: 34.0))
        btnView.setImage(UIImage(named: "btn_caretleft_bold")!, for: .normal)
        btnView.addTarget(self, action: #selector(didTapTextFieldButton), for: .touchUpInside)
        commentTextField.rightView = btnView
        commentTextField.rightViewMode = .always
        
        commentImageView.image = UIImage(named: "icon-chat-bubble-dots-mono")
        commentCountLabel.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        commentCountLabel.font = .systemFont(ofSize: 14.0, weight: .medium)
    }
    

    
    func setupHeaderView() {
        let headerLabel = UILabel()
        let backButton = UIButton()
        let dotButton = UIButton()
        
        [headerLabel,backButton,saveButton,dotButton].forEach {
            headerView.addSubview($0)
        }
        
        headerLabel.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(headerLabel)
        }
        
        dotButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(headerLabel)
        }
        
        saveButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.trailing.equalTo(dotButton.snp.leading).offset(4.0)
            $0.centerY.equalTo(dotButton)
        }
        
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        dotButton.setImage(UIImage(named: "icon-dots"), for: .normal)
        dotButton.addTarget(self, action: #selector(didTapDotButton), for: .touchUpInside)

        headerLabel.text = "커뮤니티"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .black1
        headerLabel.textAlignment = .center
        
        thumbsUpButton.setTitle(" 추천", for: .normal)
        thumbsUpButton.setImage(UIImage(named: "icon-thumb-up-mono"), for: .normal)
        thumbsUpButton.setTitleColor(.primary, for: .normal)
        thumbsUpButton.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .medium)
        thumbsUpButton.addTarget(self, action: #selector(didTapThumbsUpButton), for: .touchUpInside)
    }
    
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
                            self.likeButton()
                            likeCount += 1
                            thumbsUpButton.setTitle(" 추천 \(likeCount)", for: .normal)
                        }
                        
                    } else {
                        DispatchQueue.main.async {
                            self.disLikeButton()
                            likeCount -= 1
                            thumbsUpButton.setTitle(" 추천 \(likeCount)", for: .normal)
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
                        self.presentCutomAlert1VC(target: "didDeletePost", title: "글 삭제 완료", message: "삭제되었습니다.")
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
                        self.presentCutomAlert1VC(target: "didReportCommunityUser", title: "해당 사용자 신고 완료", message: "신고되었습니다.")
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
                        self.presentCutomAlert1VC(target: "didReportCommunityComment", title: "해당 사용자 신고 완료", message: "신고되었습니다.")
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
                    DispatchQueue.main.async {
                        self.presentCutomAlert1VC(target: "DeletedCommunityComment", title: "댓글 삭제 완료", message: "삭제되었습니다.")
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
