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
    let contentView = UIView()
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
