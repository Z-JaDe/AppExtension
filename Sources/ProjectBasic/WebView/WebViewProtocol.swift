//
//  WebViewProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/25.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import WebKit
import RxSwift
public protocol WebViewProtocol {
    var scrollView: UIScrollView {get}
    func checkAndGoBack() -> Bool
    func load(request: URLRequest)
    func load(htmlString: String)

    var rxDidFinishLoad: Observable<Void> {get}

    func reloadWeb()
}
extension WebViewProtocol {
    public func load(urlStr: String) {
        if urlStr.hasPrefix("http") {
            if let url = URL(string: urlStr) {
                self.load(request: URLRequest(url: url))
            }
        } else {
            self.load(htmlString: urlStr)
        }
    }
}

extension UIWebView: WebViewProtocol {
    public func load(htmlString: String) {
        self.loadHTMLString(htmlString, baseURL: nil)
    }

    public func load(request: URLRequest) {
        self.loadRequest(request)
    }

    public func checkAndGoBack() -> Bool {
        if self.canGoBack {
            self.goBack()
            return true
        } else {
            return false
        }
    }
    public var rxDidFinishLoad: Observable<Void> {
        self.rx.didFinishLoad
    }

    public func reloadWeb() {
        self.reload()
    }
}
extension WKWebView: WebViewProtocol {
    public func load(request: URLRequest) {
        self.load(request)
    }
    public func load(htmlString: String) {
        self.loadHTMLString(htmlString, baseURL: nil)
    }

    public func checkAndGoBack() -> Bool {
        if self.canGoBack {
            self.goBack()
            return true
        } else {
            return false
        }
    }
    public var rxDidFinishLoad: Observable<Void> {
        self.rx.didFinishLoad
    }

    public func reloadWeb() {
        let _: WKNavigation? = self.reload()
    }
}
