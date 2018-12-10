//
//  WKWebView+Rx.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/5.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit
extension Reactive where Base: WKWebView {
    public var delegate: DelegateProxy<WKWebView, WKNavigationDelegate> {
        return RxWKWebViewDelegateProxy.proxy(for: base)
    }

    public var didStartLoad: Observable<Void> {
        return delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_: didStartProvisionalNavigation: )))
            .map {_ in}
    }

    /// Reactive wrapper for `delegate` message.
    public var didFinishLoad: Observable<Void> {
        return delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_: didFinish: )))
            .map {_ in}
    }

    /// Reactive wrapper for `delegate` message.
    public var didFailLoad: Observable<Error> {
        return delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_: didFail: withError: )))
            .map { a in
                return try self.castOrThrow(Error.self, a[2])
        }
    }

    private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
        guard let returnValue = object as? T else {
            throw RxCocoaError.castingError(object: object, targetType: resultType)
        }
        return returnValue
    }
}
