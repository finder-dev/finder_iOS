//
//  WebViewController.swift
//  F!nder
//
//  Created by 장선영 on 2022/07/17.
//

import UIKit
import SnapKit
import WebKit

/*
 * 이용약관 웹뷰 입니다.
 */
class WebViewController: UIViewController {
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(headerTitleLabel)
        view.addSubview(headerBackButton)
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var headerTitleLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.text = "서비스 이용약관"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var headerBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapHeaderBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var webView : WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private var url : URL = URL(string: "https://pineapple-session-93c.notion.site/513cc9a19e4f40c491b43fa025340898")!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        [emptyView,
         headerView,
         webView].forEach {
            self.view.addSubview($0)
        }
        
//        url = URL(string: "https://www.naver.com")!
        webView.load(URLRequest(url: url))
        
        layout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func didTapHeaderBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func layout() {
        NSLayoutConstraint.activate([
            emptyView.topAnchor.constraint(equalTo: self.view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            
            webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: self.emptyView.bottomAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 48.0),
        ])
        
        headerLayout()
    }
    
    func headerLayout() {
        NSLayoutConstraint.activate([
            headerBackButton.heightAnchor.constraint(equalToConstant: 56.0),
            headerBackButton.widthAnchor.constraint(equalToConstant: 56.0),
            headerBackButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerBackButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            headerBackButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            headerTitleLabel.leadingAnchor.constraint(equalTo: headerBackButton.trailingAnchor),
            headerTitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            headerTitleLabel.centerYAnchor.constraint(equalTo: headerBackButton.centerYAnchor),
            headerTitleLabel.heightAnchor.constraint(equalToConstant: 24.0)
        ])
    }
}

