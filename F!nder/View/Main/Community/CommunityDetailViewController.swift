//
//  CommunityDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import UIKit
import SnapKit
import MaterialComponents.MaterialBottomSheet


class CommunityDetailViewController: UIViewController, UITextFieldDelegate, AlertMessage2Delegate , AlertMessageDelegate{
    
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
        }
    }
   
    func okButtonTapped(from: String) {
        if from == "didDeletePost" || from == "didReportCommunityUser" || from == "DeletedCommunityComment" || from == "didReportCommunityComment" {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    let saveButton = UIButton(type: .custom)
    
    let headerView = UIView()
    let questionImageView = UIImageView()
    let mbtiCategoryLabel = UILabel()
    let titleLabel = UILabel()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
//    let saveButton = UIButton()
    
    let lineView = UIView()
    let contentLabel = UILabel()
    let lineView2 = UIView()
    let emptyView = UIView()
    var communityId : Int?
    var communityUserId : String?
    
    var textFieldView = UIView()
    var commentTextField = UITextField()
    var btnView = UIButton()
    var textFieldYValue = CGFloat(0)
    let tableView = UITableView()
    var commentDataList = [answerHistDtos]()

    let communityNetwork = CommunityAPI()
    var answerID = -1
    
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
        
        if !data.isQuestion {
            questionImageView.isHidden = true
        }
        
        if data.saveUser {
            saveButton.setImage(UIImage(named: "saved2"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        }
        
        guard let communityData = data.answerHistDtos else {
            return
        }
        
        self.commentDataList = communityData
        self.communityUserId = "\(data.userId)"
        tableView.reloadData()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DebateCommentTableViewCell.self, forCellReuseIdentifier: DebateCommentTableViewCell.identifier)
    }
    
    // 옵저버 등록
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reportDebateUser), name: Notification.Name("reportUser"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(blockDebateUser), name: Notification.Name("blockUser"), object: nil)
        setupNavigationAttribute()
    }
    
    @objc func blockDebateUser() {
        print("===========blockCommunityUser")
    }
    
    @objc func reportDebateUser() {
        print("===========reportCommunityUser")
    
        self.presentCutomAlert2VC(target: "reportCommunityUser",
                                  title: "해당 사용자를 신고하시겠습니까?",
                                  message: "허위 신고일 경우, 활동이 제한될 수 있으니\n신중히 신고해주세요.",
                                  leftButtonTitle: "취소",
                                  rightButtonTitle: "신고")
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
        self.navigationController?.navigationBar.tintColor = .blackTextColor
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

extension CommunityDetailViewController: UITableViewDelegate, UITableViewDataSource, CommentCellDelegate {
    
    func report(answerID: Int) {
        
        presentCutomAlert2VC(target: "reportCommunityComment",
                             title: "해당 사용자를 신고하시겠습니까?",
                             message: "허위 신고일 경우, 활동이 제한될 수 있으니 신중히 신고해주세요.",
                             leftButtonTitle: "취소",
                             rightButtonTitle: "신고")
        self.answerID = answerID
    }
    
    func delete(answerID: Int) {
        presentCutomAlert2VC(target: "deleteCommunityComment",
                             title: "댓글을 삭제하시겠습니까?",
                             message: "",
                             leftButtonTitle: "네",
                             rightButtonTitle: "아니요")
        self.answerID = answerID
    }
    
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


extension CommunityDetailViewController {
    func layout() {
        
        [headerView,
         mbtiCategoryLabel,
         questionImageView,
         titleLabel,
         userMBTILabel,
         userNameLabel,
         timeLabel,
         lineView,
         contentLabel,
         lineView2,
         emptyView,
         tableView,
         textFieldView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
//        headerView.snp.makeConstraints {
//            $0.top.leading.trailing.equalTo(safeArea)
//            $0.height.equalTo(48.0)
//        }
        
//        mbtiCategoryLabel.snp.makeConstraints {
//            $0.top.equalTo(headerView.snp.bottom).offset(16.0)
//            $0.leading.equalToSuperview().inset(20.0)
//            $0.width.equalTo(43.0)
//            $0.height.equalTo(30.0)
//        }
        
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
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp.bottom)
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
         mbtiCategoryLabel.textColor = .blackTextColor
         mbtiCategoryLabel.font = .systemFont(ofSize: 12.0, weight: .medium)
         mbtiCategoryLabel.textAlignment = .center
        
        titleLabel.textColor = .blackTextColor
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
        commentTextField.placeholder = "토론에 참여해보세요!"
        commentTextField.layer.cornerRadius = 15.0//ic_baseline-arrow-forward
        commentTextField.addLeftPadding(padding: 16.0)
        btnView = UIButton(frame: CGRect(x: 0, y: 0, width: 34.0, height: 34.0))
        btnView.setImage(UIImage(named: "btn_caretleft_bold")!, for: .normal)
        btnView.addTarget(self, action: #selector(didTapTextFieldButton), for: .touchUpInside)
        commentTextField.rightView = btnView
        commentTextField.rightViewMode = .always
    }
    
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
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapDotButton() {
        let userId = UserDefaults.standard.string(forKey: "userId")
        
        guard let userId = userId,
              let communityUserId = communityUserId else {
            return
        }
        
        if userId == communityUserId {
            DispatchQueue.main.async {
                self.presentCutomAlert2VC(target: "deletePost",
                                          title: "글을 삭제하시겠습니까?",
                                          message: "",
                                          leftButtonTitle: "네",
                                          rightButtonTitle: "아니요")
            }
           
//            presentMyPostActionSheet()
        } else {
//            presentOthersPostActionSheet()
            
            let bottomSheetVC = BottomSheetViewController()
            
            let bottomSheet : MDCBottomSheetController = MDCBottomSheetController(contentViewController: bottomSheetVC)
            bottomSheet.mdc_bottomSheetPresentationController?.preferredSheetHeight = 200
            
            present(bottomSheet, animated: true)
            
//            DispatchQueue.main.async {
//                self.presentCutomAlert2VC(target: "reportCommunityUser",
//                                          title: "해당 사용자를 신고하시겠습니까?",
//                                          message: "허위 신고일 경우, 활동이 제한될 수 있으니\n신중히 신고해주세요.",
//                                          leftButtonTitle: "취소",
//                                          rightButtonTitle: "신고")
//            }
            
        }

    }
    
    func presentMyPostActionSheet() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {_ in
            self.presentCutomAlert2VC(target: "deletePost", title: "글을 삭제하시겠습니까?", message: "", leftButtonTitle: "네", rightButtonTitle: "아니요")
            print("delete")
        }
        let closeAction = UIAlertAction(title: "닫기", style: .cancel)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(closeAction)
        self.present(actionSheet, animated: true)
    }
    
    func presentOthersPostActionSheet() {
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "신고", style: .destructive) {_ in
            self.presentCutomAlert2VC(target: "reportCommunityUser",
                                      title: "해당 사용자를 신고하시겠습니까?",
                                      message: "허위 신고일 경우, 활동이 제한될 수 있으니\n신중히 신고해주세요.",
                                      leftButtonTitle: "취소",
                                      rightButtonTitle: "신고")
            print("report")
        }
        let closeAction = UIAlertAction(title: "닫기", style: .cancel)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(closeAction)
        self.present(actionSheet, animated: true)
    }
    
    
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
                            navigationItem.rightBarButtonItems?[0].tintColor = .mainTintColor
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
}
