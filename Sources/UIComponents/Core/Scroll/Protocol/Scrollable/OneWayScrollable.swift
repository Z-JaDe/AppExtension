//
//  OneWayScrollable.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/26.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public enum ScrollDirection {
    case horizontal
    case vertical
}
public protocol OneWayScrollable: Scrollable {
    var scrollDirection: ScrollDirection {get}
}
public extension OneWayScrollable {
    /// ZJaDe: 视图中心的contentOffset
    func viewCenterOffset() -> CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.contentOffset.x + self.frame.size.width / 2
        case .vertical:
            return self.contentOffset.y + self.frame.size.height / 2
        }
    }
    func viewHeadOffset() -> CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.contentOffset.x
        case .vertical:
            return self.contentOffset.y
        }
    }
    func viewTailOffset() -> CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.contentOffset.x + self.frame.size.width
        case .vertical:
            return self.contentOffset.y + self.frame.size.height
        }
    }
    /// ZJaDe: scrollView的宽度或者高度
    var length: CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.frame.size.width
        case .vertical:
            return self.frame.size.height
        }
    }
    /// ZJaDe: 水平方向上的高度，竖直方向上的宽度
    var length2: CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.frame.size.height
        case .vertical:
            return self.frame.size.width
        }
    }
    var contentLength: CGFloat {
        get {
            switch self.scrollDirection {
            case .horizontal:
                return self.contentSize.width
            case .vertical:
                return self.contentSize.height
            }
        }set {
            switch self.scrollDirection {
            case .horizontal:
                self.contentSize.width = newValue
            case .vertical:
                self.contentSize.height = newValue
            }
        }
    }
    /// ZJaDe: 滚动到指定的offSet
    func scrollTo(offSet: CGFloat, animated: Bool = true) {
        switch self.scrollDirection {
        case .horizontal:
            self.setContentOffset(CGPoint(x: offSet, y: self.contentOffset.y), animated: animated)
        case .vertical:
            self.setContentOffset(CGPoint(x: self.contentOffset.x, y: offSet), animated: animated)
        }
    }
}
public extension OneWayScrollable where Self: UIScrollView {
    func adjustAlwaysBounce() {
        switch scrollDirection {
        case .horizontal:
            self.alwaysBounceHorizontal = true
            self.alwaysBounceVertical = false
        case .vertical:
            self.alwaysBounceHorizontal = false
            self.alwaysBounceVertical = true
        }
    }
}
