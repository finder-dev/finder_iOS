//
//  MakeDiscussViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/14.
//

import UIKit
import SnapKit
import RxSwift

final class MakeDebateViewController: BaseViewController, UITextFieldDelegate {
    
    let debateTitleTextField = UITextField()
    let textFieldA = UITextField()
    let textFieldB = UITextField()
    
    let lineView1 = BarView(barHeight: 1.0, barColor: .grey11)
    let lineView2 = BarView(barHeight: 9.0, barColor: .grey10)
    let lineView3 = BarView(barHeight: 1.0, barColor: .grey11)
    
    let infoLabel = FinderLabel(text: "토론은 일주일간 진행됩니다. \n올리면 수정, 삭제가 안되니 신중하게 적어주세요!",
                                font: .systemFont(ofSize: 16.0, weight: .regular),
                                textColor: .grey3)
    
    let debateNetwork = DebateAPI()
    
    let completeButton = UIBarButtonItem(title: "완료",
                                         style: .plain,
                                         target: nil,
                                         action: nil)
    let closeButton = UIBarButtonItem(image: UIImage(named: "ic_baseline-close"),
                                                     style: .plain,
                                                     target: nil,
                                                     action: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        
        [debateTitleTextField, textFieldA, textFieldB, lineView1, lineView2, lineView3,
         infoLabel].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setLayout() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        debateTitleTextField.snp.makeConstraints {
            $0.top.equalTo(safeArea).inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(54.0)
        }
        
        lineView1.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(debateTitleTextField.snp.bottom)
        }
        
        textFieldA.snp.makeConstraints {
            $0.top.equalTo(lineView1.snp.bottom).offset(15.5)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(52.0)
        }
        
        textFieldB.snp.makeConstraints {
            $0.top.equalTo(textFieldA.snp.bottom).offset(12.0)
            $0.leading.trailing.equalTo(textFieldA)
            $0.height.equalTo(52.0)
        }
        
        lineView2.snp.makeConstraints {
            $0.top.equalTo(textFieldB.snp.bottom).offset(24.0)
            $0.leading.trailing.equalToSuperview()
        }
        
        lineView3.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(lineView2)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(lineView2.snp.bottom).offset(15.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
    }
    
    override func setupView() {
        self.view.backgroundColor = .white
        self.title = "토론생성"

        completeButton.isEnabled = false
        self.navigationItem.rightBarButtonItem = completeButton
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem?.tintColor = .lightGray
        
        [debateTitleTextField,textFieldA,textFieldB].forEach {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        debateTitleTextField.placeholder = "토론 제목을 입력하세요."
        textFieldA.placeholder = "A선택지를 8자 이내로 입력해주세요"
        textFieldB.placeholder = "B선택지를 8자 이내로 입력해주세요"
        
        [textFieldA,textFieldB].forEach {
            $0.backgroundColor = .grey11.withAlphaComponent(0.5)
            $0.addLeftPadding(padding: 12.0)
        }

        infoLabel.setLineHeight(lineHeight: 24.0)
    }
    
    override func bindViewModel() {
//        completeButton.rx.tap
//            .subscribe(onNext: { [weak self] in
//
//            })
//            .disposed(by: disposeBag)
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// textField
extension MakeDebateViewController {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let title = debateTitleTextField.text,
              let optionA = textFieldA.text,
              let optionB = textFieldB.text else {
            return
        }
        
        if !title.isEmpty && !optionA.isEmpty && !optionB.isEmpty {
            completeButton.isEnabled = true
            completeButton.tintColor = .primary
        } else {
            completeButton.isEnabled = false
            completeButton.tintColor = .lightGray
        }
    }
}

extension MakeDebateViewController {
    
    @objc func didTapRightBarButton() {
        print("didTapRightBarButton")
        
        guard let title = debateTitleTextField.text,
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
