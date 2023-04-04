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
final class WebViewController: UIViewController {
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }()
   
    private lazy var headerView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(headerTitleLabel)
        view.addSubview(headerBackButton)
        view.layer.masksToBounds = false
        return view
    }()
    
    private let headerTitleLabel = FinderLabel(text: "서비스 이용약관",
                                               font: .systemFont(ofSize: 16.0, weight: .bold),
                                               textColor: .black,
                                               textAlignment: .center)
    
    
    private lazy var headerBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ic_baseline-close"), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(didTapHeaderBackButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var webView : WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.backgroundColor = .yellow
        webView.navigationDelegate = self
        return webView
    }()
    
    private let url : URL = URL(string: "https://pineapple-session-93c.notion.site/513cc9a19e4f40c491b43fa025340898")!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        [headerView, webView, indicator].forEach {
            self.view.addSubview($0)
        }
        
        webView.load(URLRequest(url: url))
        layout()
    }

    @objc func didTapHeaderBackButton() {
        self.dismiss(animated: false)
    }
    
    func layout() {
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
        }
        
        headerBackButton.snp.makeConstraints {
            $0.height.width.equalTo(56.0)
            $0.leading.centerY.equalTo(headerView)
            $0.centerY.equalTo(headerView)
        }
        
        headerTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(headerBackButton.snp.trailing)
            $0.centerX.centerY.equalTo(headerView)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom).offset(50)
        }
        
        webView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}
