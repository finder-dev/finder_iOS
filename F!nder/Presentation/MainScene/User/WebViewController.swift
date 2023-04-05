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
    
    private let headerView = HeaderView(title: "서비스 이용약관")

    private lazy var webView : WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptCanOpenWindowsAutomatically = true
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preference
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = self
        return webView
    }()
    
    private let url : URL = URL(string: "https://pineapple-session-93c.notion.site/513cc9a19e4f40c491b43fa025340898")!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        layout()
        
        webView.load(URLRequest(url: url))
        headerView.closeButton.addTarget(self, action: #selector(didTapHeaderBackButton), for: .touchUpInside)
    }

    @objc func didTapHeaderBackButton() {
        self.dismiss(animated: false)
    }
    
    func layout() {
        
        [headerView, webView, indicator].forEach {
            self.view.addSubview($0)
        }
        
        let safeArea = self.view.safeAreaLayoutGuide
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48.0)
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
