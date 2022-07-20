//
//  CommunityDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/19.
//

import UIKit
import SnapKit

class CommunityDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
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
        }
        
        return cell
    }
    
    
    let headerView = UIView()
    let questionImageView = UIImageView()
    let mbtiCategoryLabel = UILabel()
    let titleLabel = UILabel()
    let userMBTILabel = UILabel()
    let userNameLabel = UILabel()
    let timeLabel = UILabel()
    let saveButton = UIButton()
    
    let lineView = UIView()
    let contentLabel = UILabel()
    let lineView2 = UIView()
    let emptyView = UIView()
    var communityId : Int?
    
    var textFieldView = UIView()
    var commentTextField = UITextField()
    var btnView = UIButton()
    var textFieldYValue = CGFloat(0)
    let tableView = UITableView()
    var commentDataList = [answerHistDtos]()

    let communityNetwork = CommunityAPI()
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
            saveButton.setImage(UIImage(named: "saved"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        }
        
        guard let communityData = data.answerHistDtos else {
            return
        }
        
        self.commentDataList = communityData
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
    }
    
    // 옵저버 해제
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeArea)
            $0.height.equalTo(48.0)
        }
        
        mbtiCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16.0)
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
            $0.height.equalTo(26.0)
            $0.leading.equalTo(mbtiCategoryLabel)
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
        
        [headerLabel,backButton,saveButton].forEach {
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
        
        saveButton.snp.makeConstraints {
            $0.width.height.equalTo(24.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(headerLabel)
        }
        
        backButton.setImage(UIImage(named: "backButton"), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        saveButton.setImage(UIImage(named: "Frame 986353"), for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)

        headerLabel.text = "커뮤니티"
        headerLabel.font = .systemFont(ofSize: 16.0, weight: .bold)
        headerLabel.textColor = .blackTextColor
        headerLabel.textAlignment = .center
    }
    
    @objc func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
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
                            saveButton.setImage(UIImage(named: "saved"), for: .normal)
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

