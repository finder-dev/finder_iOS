//
//  MakeDiscussViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/14.
//

import UIKit
import SnapKit

class MakeDiscussViewController: UIViewController, UITextFieldDelegate {
    
    let discussTitleTextField = UITextField()
    let textFieldA = UITextField()
    let textFieldB = UITextField()
    
    let lineView = UIView()
    let emptyView = UIView()
    
    let infoLabel = UILabel()
    let debateNetwork = DebateAPI()
    
    let rightBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapRightBarButton))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        attribute()
        
        [discussTitleTextField,textFieldA,textFieldB].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
    }
}

// textField
extension MakeDiscussViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let title = discussTitleTextField.text,
              let optionA = textFieldA.text,
              let optionB = textFieldB.text else {
            return
        }
        
        if !title.isEmpty && !optionA.isEmpty && !optionB.isEmpty {
            rightBarButton.isEnabled = true
            rightBarButton.tintColor = .mainTintColor
        } else {
            rightBarButton.isEnabled = false
            rightBarButton.tintColor = .lightGray
        }
    }
}

private extension MakeDiscussViewController {
    func layout() {
        [discussTitleTextField,
         textFieldA,
         textFieldB,
         lineView,
         emptyView,
         infoLabel].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        discussTitleTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea).inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(54.0)
        }
        
        lineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(discussTitleTextField.snp.bottom)
            $0.height.equalTo(1.0)
        }
        
        textFieldA.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(15.5)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(52.0)
        }
        
        textFieldB.snp.makeConstraints {
            $0.top.equalTo(textFieldA.snp.bottom).offset(12.0)
            $0.leading.trailing.equalTo(textFieldA)
            $0.height.equalTo(52.0)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(textFieldB.snp.bottom).offset(24.0)
            $0.height.equalTo(9.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(emptyView.snp.bottom).offset(15.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
    }
    
    func attribute() {
        self.view.backgroundColor = .white
        setupNavigationBar()
        discussTitleTextField.placeholder = "토론 제목을 입력하세요."
        lineView.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 1.0)
        textFieldA.placeholder = "A선택지를 8자 이내로 입력해주세요"
        textFieldB.placeholder = "B선택지를 8자 이내로 입력해주세요"
        
        [textFieldA,textFieldB].forEach {
            $0.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.5)
            $0.addLeftPadding(padding: 12.0)
        }
        
        emptyView.backgroundColor = UIColor(red: 233/255, green: 234/255, blue: 239/255, alpha: 1.0)
        
        infoLabel.text = "토론은 일주일간 진행됩니다. \n올리면 수정, 삭제가 안되니 신중하게 적어주세요!"
        infoLabel.numberOfLines = 0
        infoLabel.font = .systemFont(ofSize: 16.0, weight: .regular)
        infoLabel.textColor = UIColor(red: 188/255, green: 188/255, blue: 188/255, alpha: 1.0)
        infoLabel.setLineHeight(lineHeight: 24.0)
    }
}

// 네비게이션 바 설정
extension MakeDiscussViewController {
    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "토론생성"
        
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_baseline-close"), style: .plain, target: self, action: #selector(didTapLeftBarButton))
        
//        let rightBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapRightBarButton))
        rightBarButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationController?.navigationBar.tintColor = .blackTextColor
        self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
    }
    
    @objc func didTapLeftBarButton() {
        print("didTapLeftBarButton")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton")
        
        guard let title = discussTitleTextField.text,
              let optionA = textFieldA.text,
              let optionB = textFieldB.text else {
            return
        }
    
        debateNetwork.requestMakeDebate(title: title,
                                        optionA: optionA,
                                        optionB: optionB) { [self] result in
            
            switch result {
            case let .success(response) :
                if response.success {
                    print("성공 : 새로운 토론 만들기")
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    print("실패 : 새로운 토론 만들기")
                    print(response.errorResponse?.errorMessages)
                }
            case .failure(_):
                print("오류")
            }
            
        }
    }
}
