//
//  WKWebView.swift
//  Any
//
//  Created by ZJaDe on 2018/6/14.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import WebKit
open class JDWKWebView: WKWebView, WritableDefaultHeightProtocol {
    public var defaultHeight: CGFloat = 100 {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
    open override var intrinsicContentSize: CGSize {
        var resultSize = super.intrinsicContentSize
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    open override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        var resultSize = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var resultSize = super.sizeThatFits(size)
        if self.defaultHeight > 0 {
            resultSize.height = self.defaultHeight
        }
        return resultSize
    }
}
