//
//  BaseViewController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit

class BaseViewController: UIViewController {
    
    // MARK: Properties
    
    let commentRelay = PublishRelay<String>()
    let disposeBag = DisposeBag()
    lazy var commentViewBottomConstraint: NSLayoutConstraint = commentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
    
    // MARK: Views
    
    let scrollView = UIScrollView()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    let commentView = CommentTextFieldView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        setupView()
        setLayout()
        bindViewModel()
        
        addKeyboardObserver()
//        hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }

    func addView() {
        [scrollView, commentView].forEach {
            self.view.addSubview($0)
        }
        scrollView.addSubview(stackView)
    }
    
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeArea)
        }
        
        commentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        
        commentViewBottomConstraint.isActive = true
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
    
    func setupView() { }

    func bindViewModel() {
        commentView.addCommentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let comment = self?.commentView.commentTextField.text else {
                    return
                }
                self?.commentRelay.accept(comment)
            })
            .disposed(by: disposeBag)
    }
}

private extension BaseViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                  return
              }
        keyboardFrame = self.stackView.convert(keyboardFrame, from: nil)
        let keyboardHeight = keyboardFrame.size.height
        
        var contentInset = scrollView.contentInset
        if contentInset.bottom < keyboardHeight {
            contentInset.bottom += keyboardHeight
        }
        scrollView.contentInset.bottom = contentInset.bottom
        commentViewBottomConstraint.constant = -keyboardHeight
        
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        
        scrollView.contentInset.bottom = commentView.bounds.size.height
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
        commentViewBottomConstraint.constant = .zero
        
        UIView.animate(withDuration: 0.3,
                       animations: { self.view.layoutIfNeeded()},
                       completion: nil)
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
