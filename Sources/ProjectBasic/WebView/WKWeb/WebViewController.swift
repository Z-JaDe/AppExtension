//
//  WebViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/29.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

open class WebViewController: BaseWebViewController<JDWKWebView>, WKNavigationDelegate {
    /// ZJaDe: 
    public private(set) lazy var jsBridge: JSBridge = JSBridge(libraryCode: "", functionNamespace: "appNative")
    /// ZJaDe: 
    let uiProxy: WKUIProxy = WKUIProxy()
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.allowsBackForwardNavigationGestures = true
        self.rootView.uiDelegate = self.uiProxy
        self.rootView.navigationDelegate = self
    }
    open override func createView(_ frame: CGRect) -> JDWKWebView {
        self.jsBridge.webView
    }

    // MARK: - WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    public var decidePolicyClosure: ((_ navigationAction: WKNavigationAction, _ decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) -> Void)?
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let closure = self.decidePolicyClosure {
            closure(navigationAction, decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }
}
