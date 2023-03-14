//
//  BaseViewController.swift
//  F!nder
//
//  Created by 장선영 on 2023/03/11.
//

import UIKit
import RxSwift
import SnapKit

class BaseViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addView()
        setupView()
        setLayout()
        bindViewModel()
        
        addKeyboardObserver()
        hideKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }

    func addView() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)
    }
    
    func setLayout() {
        let safeArea = view.safeAreaLayoutGuide
        
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(safeArea)
        }
        
        stackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalToSuperview()
        }
    }
    
    func setupView() {}

    func bindViewModel() {}
}

private extension BaseViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardDidShowNotification,
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
        NotificationCenter.default.removeObserver(UIResponder.keyboardDidShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                  return
              }
        keyboardFrame = self.stackView.convert(keyboardFrame, from: nil)
        var contentInset = scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset.bottom = contentInset.bottom
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = self.scrollView.contentInset
    }
    
    func hideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
