//
//  LayoutMultipleItemCell.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/28.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public final class LayoutMultipleItemCell<View: UIView>: Equatable {

    internal var itemSpace: ItemSpace = .leading(0)
    internal var scrollDirection: ScrollDirection = .horizontal

    internal let view: View
    internal init(_ view: View) {
        self.view = view
    }
    public func sizeThatFits() -> CGSize {
        var resultSize = self.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        switch self.scrollDirection {
        case .horizontal:
            resultSize.width += self.itemSpace.space
        case .vertical:
            resultSize.height += self.itemSpace.space
        }
        return resultSize
    }
    /// ZJaDe: 
    public static func == (lhs: LayoutMultipleItemCell<View>, rhs: LayoutMultipleItemCell<View>) -> Bool {
        return lhs.view == rhs.view
    }
    /// ZJaDe: 
    public var leading: CGFloat {
        get {
            switch (self.scrollDirection, self.itemSpace) {
            case (.horizontal, .leading):
                return self.view.left
            case (.horizontal, .center(let space)):
                return self.view.left - space / 2
            case (.vertical, .leading):
                return self.view.top
            case (.vertical, .center(let space)):
                return self.view.top - space / 2
            }
        }set {
            switch (self.scrollDirection, self.itemSpace) {
            case (.horizontal, .leading):
                self.view.left = newValue
            case (.horizontal, .center(let space)):
                self.view.left = newValue + space / 2
            case (.vertical, .leading):
                self.view.top = newValue
            case (.vertical, .center(let space)):
                self.view.top = newValue + space / 2
            }
        }
    }
    public var trailing: CGFloat {
        switch (self.scrollDirection, self.itemSpace) {
        case (.horizontal, .leading(let space)):
            return self.view.right + space
        case (.horizontal, .center(let space)):
            return self.view.right + space / 2
        case (.vertical, .leading(let space)):
            return self.view.bottom + space
        case (.vertical, .center(let space)):
            return self.view.bottom + space / 2
        }
    }

    public var length: CGFloat {
        switch self.scrollDirection {
        case .horizontal:
            return self.view.width + self.itemSpace.space
        case .vertical:
            return self.view.height + self.itemSpace.space
        }
    }
    internal func changeSize(_ newValue: CGSize) {
        switch self.scrollDirection {
        case .horizontal:
            self.view.size = CGSize(width: newValue.width - self.itemSpace.space, height: newValue.height)
        case .vertical:
            self.view.size = CGSize(width: newValue.width, height: newValue.height - self.itemSpace.space)
        }
    }
}
