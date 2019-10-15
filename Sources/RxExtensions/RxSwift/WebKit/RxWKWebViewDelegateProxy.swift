//
//  RxWKWebViewDelegateProxy.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/7/5.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
extension WKWebView: HasDelegate {
    public typealias Delegate = WKNavigationDelegate

    public var delegate: WKNavigationDelegate? {
        get {return self.navigationDelegate}
        set {self.navigationDelegate = newValue}
    }
}

open class RxWKWebViewDelegateProxy: DelegateProxy<WKWebView, WKNavigationDelegate>, DelegateProxyType, WKNavigationDelegate {

    /// Typed parent object.
    public weak private(set) var webView: WKWebView?

    /// - parameter webView: Parent object for delegate proxy.
    public init(webView: ParentObject) {
        self.webView = webView
        super.init(parentObject: webView, delegateProxy: RxWKWebViewDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxWKWebViewDelegateProxy(webView: $0) }
    }
}
