//
//  BaseWebViewController.swift
//  SNKit
//
//  Created by ZJaDe on 2018/6/12.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift
import WebKit

open class BaseWebViewController<ViewType>: GenericsViewController<ViewType> where ViewType: WKWebView & WritableDefaultHeightProtocol {
    // MARK: -
    /// ZJaDe: 需要手动实现，内部无实现
    public var needURLParam: Bool = true {
        didSet { setNeedRequest() }
    }
    /// ZJaDe: 需要手动实现，内部无实现
    public var params: [String: String] = [: ] {
        didSet { setNeedRequest() }
    }
    // MARK: -
    open override func viewDidLoad() {
        super.viewDidLoad()
        configWebView()
    }
    open func configWebView() {
    }

    // MARK: -
    public var urlStr: String? {
        didSet { setNeedRequest() }
    }
    open override func request() {
        guard let urlStr = self.urlStr else { return }
        if let _self = self as? LoadWebUrlProtocol {
            _self.load(urlStr)
        } else {
            self.rootView.load(urlStr: urlStr)
        }
    }
    open override func updateData() {
        self.rootView.reload()
    }
    // MARK: -
    /// ZJaDe: autoUpdateHeightWithContentSize
    open func autoUpdateHeightWithContentSize() {
        DispatchQueue.main.async {
            self.rootView.scrollView.isScrollEnabled = false
            self.rootView.rx.didFinishLoad.subscribeOnNext {[weak self] () in
                self?.calculateUpdateWebViewHeight()
                }.disposed(by: self.disposeBag)
        }
    }
    /// ZJaDe: 更新高度
    func calculateUpdateWebViewHeight() {
        guard let view = self.rootView.scrollView.subviews.filter({($0 is UIImageView) == false}).max(by: {$0.bottom > $1.bottom}) else {
            return
        }
        let height = view.sizeThatFits(CGSize(width: self.rootView.width, height: CGFloat.greatestFiniteMagnitude)).height
        self.updateWebView(height: height)
    }
    public func updateWebView(height: CGFloat) {
        if self.rootView.defaultHeight != height {
            self.rootView.defaultHeight = height
        }
    }
}
extension WKWebView {
    public func load(urlStr: String) {
        if urlStr.hasPrefix("http") {
            if let url = URL(string: urlStr) {
                load(URLRequest(url: url))
            }
        } else {
            loadHTMLString(urlStr, baseURL: nil)
        }
    }

}
