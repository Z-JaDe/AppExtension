//
//  BaseWebViewController.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/6/12.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
import RxSwift

open class BaseWebViewController<ViewType>: ViewController<ViewType> where ViewType: UIView & WebViewProtocol & WritableDefaultHeightProtocol {
    // MARK: -
    /// ZJaDe: 需要手动实现，内部无实现
    public var needURLParam: Bool = true {
        didSet {
            self.setNeedRequest()
        }
    }
    /// ZJaDe: 需要手动实现，内部无实现
    public var params: [String: String] = [: ] {
        didSet {
            self.setNeedRequest()
        }
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
            self.sn_view.load(urlStr: urlStr)
        }
    }
    open override func updateData() {
        self.sn_view.reloadWeb()
    }
    // MARK: -
    /// ZJaDe: autoUpdateHeightWithContentSize
    open func autoUpdateHeightWithContentSize() {
        Async.main {
            self.sn_view.scrollView.isScrollEnabled = false
            self.sn_view.rxDidFinishLoad.subscribeOnNext {[weak self] () in
                self?.calculateUpdateWebViewHeight()
                }.disposed(by: self.disposeBag)
        }
    }
    /// ZJaDe: 更新高度
    func calculateUpdateWebViewHeight() {
        guard let view = self.sn_view.scrollView.subviews.filter({($0 is UIImageView) == false}).max(by: {$0.bottom > $1.bottom}) else {
            return
        }
        let height = view.sizeThatFits(CGSize(width: self.sn_view.width, height: CGFloat.greatestFiniteMagnitude)).height
        self.updateWebView(height: height)
    }
    public func updateWebView(height: CGFloat) {
        if self.sn_view.defaultHeight != height {
            self.sn_view.defaultHeight = height
        }
    }
}
