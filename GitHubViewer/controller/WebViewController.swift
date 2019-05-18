//
//  WebViewController.swift
//  GitHubViewer
//
//  Created by hitting on 2019/05/19.
//  Copyright © 2019 Hit Apps. All rights reserved.
//

import UIKit
import WebKit

/// Web画面用ViewController
class WebViewController: UIViewController {
    
    /// 遷移先URL
    var url: URL!

    /// Webビュー
    private var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)
        self.webView.navigationDelegate = self
        self.view = self.webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = self.url else {
            let alertController = UIAlertController(title: "Invalid URL", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
            return
        }

        self.webView.load(URLRequest(url: url))
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
