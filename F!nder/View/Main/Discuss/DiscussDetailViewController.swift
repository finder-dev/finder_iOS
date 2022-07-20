//
//  DiscussDetailViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/14.
//

import UIKit
import SnapKit
import SwiftUI

/*
 * 토론 상세 뷰 입니다.
 */
class DiscussDetailViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
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
    
    // 토론 내용 보여주는 components
    let discussView = UIView()
    let discussTitle = UILabel()
    let timeLabel = UILabel()
    var agreeButton = UIButton()
    var agreeCounts = UILabel()
    var disagreeButton = UIButton()
    var disagreeCounts = UILabel()
    var agreeImageView = UIImageView()
    var disagreeImageView = UIImageView()
    var userMBTILabel = UILabel()
    var userNameLabel = UILabel()
    var commentCountLabel = UILabel()
    
    var textFieldView = UIView()
    var commentTextField = UITextField()
    var btnView = UIButton()
    var textFieldYValue = CGFloat(0)
    let tableView = UITableView()
    var commentDataList = [answerHistDtos]()
    lazy var constraint = textFieldView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    
    var emptyView = UIView()
    var debateID : Int?
    let debateNetwork = DebateAPI()

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
        attribute()
        commentTextField.delegate = self

        guard let debateID = debateID else {
            return
        }
        print(debateID)
        fetchDebateData(debateID: debateID)
    }

    
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
    
    func fetchData(data:DetailDebateSuccessResponse) {
        discussTitle.text = data.debateTitle
        timeLabel.text = "남은시간 \(data.deadline)"
        commentCountLabel.text = "댓글 \(data.answerCount)"
        userMBTILabel.text = data.writerMBTI
        userNameLabel.text = data.writerNickname
        agreeCounts.text = "\(data.optionACount)"
        disagreeCounts.text = "\(data.optionBCount)"
        agreeButton.setTitle(data.optionA, for: .normal)
        disagreeButton.setTitle(data.optionB, for: .normal)
        print(data)
        if data.join {
            if data.joinOption == "A" {
                agreeImageView.isHidden = false
                disagreeImageView.isHidden = true
                selectedButton(button: agreeButton)
                deSelectedButton(button: disagreeButton)
            } else if data.joinOption == "B" {
                
                disagreeImageView.isHidden = false
                agreeImageView.isHidden = true
                selectedButton(button: disagreeButton)
                deSelectedButton(button: agreeButton)
            }
        }
        print(data.answerHistDtos)
        guard let commentDataList = data.answerHistDtos else {return}
        self.commentDataList = commentDataList
        tableView.reloadData()
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

extension DiscussDetailViewController {
    
    
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


extension DiscussDetailViewController {
    
    
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
                            agreeImageView.isHidden = true
                            deSelectedButton(button: agreeButton)
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
    
    func selectedButton(button:UIButton) {
        button.backgroundColor = .selectedDebateColor
        button.setTitleColor(.white, for: .normal)
        
    }
    
    func deSelectedButton(button:UIButton) {
        button.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        button.setTitleColor(UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0), for: .normal)
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
                            disagreeImageView.isHidden = true
                            deSelectedButton(button: disagreeButton)
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
    
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton")
        
    }
    
}

private extension DiscussDetailViewController {
    func layout() {
        [discussView,emptyView,tableView,textFieldView].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        discussView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(safeArea)
        }
        
        emptyView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(discussView.snp.bottom)
            $0.height.equalTo(10.0)
        }
        
        textFieldView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(78.0)

        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(emptyView.snp.bottom)
            $0.bottom.equalTo(textFieldView.snp.top)
        }
        
        tableView.backgroundColor = .white
        
        constraint.isActive = true
        
        textFieldView.addSubview(commentTextField)
        
        commentTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(42.0)
        }
        
        discussView.backgroundColor = .white
        emptyView.backgroundColor = UIColor(red: 233/255, green: 234/255, blue: 239/255, alpha: 1.0)
        setupNavigationAttribute()
        setupDiscussViewLayout()
        textFieldView.backgroundColor = .white
        textFieldView.layer.borderWidth = 1.0
        textFieldView.layer.borderColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0).cgColor
    }
    
    
    func attribute() {
        self.view.backgroundColor = .white
        setupNavigationAttribute()
        setupDiscussViewAttribute()
        setupTableView()
        
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
        debateNetwork.requestNewComment(debateID: debateID!, content: text) { [self] result in
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 댓글 달기 ")
                    guard let response = response.response else {
                        return
                    }
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
    func setupDiscussViewLayout() {
        
        [discussTitle,
         timeLabel,
         agreeCounts,
         agreeImageView,
         disagreeCounts,
         disagreeImageView,
         commentCountLabel,
         disagreeButton,
         agreeButton,
         userMBTILabel,
         userNameLabel].forEach {
            discussView.addSubview($0)
        }
        
        let screenWidth = self.view.bounds.width
        let buttonWidth = (screenWidth - (20*2 + 13.0)) / 2
        let buttonHeight = 55.0
        
        discussTitle.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(73.0)
            $0.top.equalToSuperview().inset(24.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(discussTitle.snp.bottom).offset(4.0)
        }
        
        agreeCounts.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(screenWidth/2+22.0)
            $0.height.equalTo(64.0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(32.0)
        }
        
        agreeImageView.snp.makeConstraints {
            $0.bottom.equalTo(agreeButton.snp.top)
            $0.leading.equalTo(agreeButton)
        }
        
        disagreeImageView.snp.makeConstraints {
            $0.bottom.equalTo(disagreeButton.snp.top)
            $0.trailing.equalTo(disagreeButton)
        }
        
        disagreeCounts.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(screenWidth/2+22.0)
            $0.height.equalTo(64.0)
            $0.top.equalTo(timeLabel.snp.bottom).offset(32.0)
        }
        
        agreeButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            $0.top.equalTo(timeLabel.snp.bottom).offset(75.0)
        }
        
        disagreeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.equalTo(buttonWidth)
            $0.height.equalTo(buttonHeight)
            $0.top.equalTo(timeLabel.snp.bottom).offset(75.0)
        }
        
        userMBTILabel.snp.makeConstraints {
            $0.top.equalTo(disagreeButton.snp.bottom).offset(37.0)
            $0.centerY.equalTo(commentCountLabel)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userMBTILabel.snp.trailing).offset(20.0)
            $0.centerY.equalTo(userMBTILabel)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16.0)
            $0.trailing.equalToSuperview().inset(20.0)
        }
    }
    
    func setupDiscussViewAttribute() {
        discussTitle.font = .systemFont(ofSize: 16.0, weight: .medium)
        discussTitle.textColor = .blackTextColor
        discussTitle.textAlignment = .center
        discussTitle.numberOfLines = 0
        
        [commentCountLabel,timeLabel,userMBTILabel,userNameLabel].forEach {
            $0.font = .systemFont(ofSize: 12.0, weight: .regular)
            $0.textColor = UIColor(red: 113/255, green: 113/255, blue: 113/255, alpha: 1.0)
        }
        
        timeLabel.textAlignment = .center
        
        [agreeCounts,disagreeCounts].forEach {
            $0.font = .systemFont(ofSize: 44.0, weight: .bold)
            $0.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
            $0.text = "33"
            $0.textAlignment = .center
        }
        
        agreeButton.setTitle("물론 가능!", for: .normal)
        disagreeButton.setTitle("절대 불가능", for: .normal)
        
        [agreeButton,disagreeButton].forEach {
            $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
            $0.setTitleColor(UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0), for: .normal)
            $0.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        }
        
        agreeButton.contentHorizontalAlignment = .left
        disagreeButton.contentHorizontalAlignment = .right
        
        agreeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        agreeButton.addTarget(self, action: #selector(didTapAgreeButton), for: .touchUpInside)
        disagreeButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
        disagreeButton.addTarget(self, action: #selector(didTapDisAgreeButton), for: .touchUpInside)
        
        
        [agreeImageView,disagreeImageView].forEach {
            $0.image = UIImage(named: "Frame 986295")
            $0.isHidden = true
        }
    }
    func setupNavigationAttribute() {
        self.navigationController?.navigationBar.isHidden = false
        
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icon-siren-mono"), style: .plain, target: self, action: #selector(didTapRightBarButton))
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let backButton  = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .blackTextColor
        self.navigationItem.title = "토론"
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DebateCommentTableViewCell.self, forCellReuseIdentifier: DebateCommentTableViewCell.identifier)
    }
}
