//
//  WebViewController.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/12.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import JavaScriptCore

open class WebViewController: BaseWebViewController<WebView>, UIWebViewDelegate {

    public private(set) var jsContext: JSContext? {
        didSet { configJSMutually() }
    }

    open override func configWebView() {
        super.configWebView()
        self.sn_view.isOpaque = false
        self.sn_view.backgroundColor = Color.clear
        self.sn_view.scrollView.bounces = false
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sn_view.rx.delegate.setForwardToDelegate(self, retainDelegate: false)
    }
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sn_view.rx.delegate.setForwardToDelegate(nil, retainDelegate: false)
    }
    /// ZJaDe: jsMutually
    public var jsMutually: JSExport? {
        didSet {
            configJSMutually()
        }
    }
    func configJSMutually() {
        if let jsContext = self.jsContext, let jsMutually = self.jsMutually {
            jsContext.setObject(jsMutually.self, forKeyedSubscript: "appNative" as NSCopying & NSObjectProtocol)
        }
    }

    // MARK: - UIWebViewDelegate
    public var shouldStartLoadClosure: ((URLRequest, UIWebView.NavigationType) -> (Bool))?
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if let closure = self.shouldStartLoadClosure {
            return closure(request, navigationType)
        } else {
            return true
        }
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        if let jsContext = self.sn_view.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext {
            self.jsContext = jsContext
        }
    }
}
