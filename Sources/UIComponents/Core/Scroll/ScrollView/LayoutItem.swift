//
//  LayoutItem.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/28.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

extension ItemSpace {
    fileprivate var space: CGFloat {
        switch self {
        case .center(let space): return space
        case .leading(let space): return space
        }
    }
}

public struct LayoutItem<View: UIView>: Equatable {

    private let itemSpace: ItemSpace
    private let scrollDirection: ScrollDirection
    public let view: View
    internal init(_ view: View, _ itemSpace: ItemSpace, _ scrollDirection: ScrollDirection) {
        self.view = view
        self.itemSpace = itemSpace
        self.scrollDirection = scrollDirection
    }
    func map(_ itemSpace: ItemSpace, _ scrollDirection: ScrollDirection) -> LayoutItem {
        LayoutItem(view, itemSpace, scrollDirection)
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
    public static func == (lhs: LayoutItem, rhs: LayoutItem) -> Bool {
        lhs.view == rhs.view
    }
    /// ZJaDe: 
    public var leading: CGFloat {
        let offset: CGFloat
        switch self.itemSpace {
        case .leading:
        offset = 0
        case .center(let space):
        offset = space / 2
        }
        switch self.scrollDirection {
        case .horizontal:
        return self.view.left - offset
        case .vertical:
        return self.view.top - offset
        }
    }
    func setLeading(_ newValue: CGFloat) {
        let offset: CGFloat
        switch self.itemSpace {
        case .leading:
            offset = 0
        case .center(let space):
            offset = space / 2
        }
        switch self.scrollDirection {
        case .horizontal:
            self.view.left = newValue + offset
        case .vertical:
            self.view.top = newValue + offset
        }
    }
    public var trailing: CGFloat {
        let offset: CGFloat
        switch self.itemSpace {
        case .leading(let space):
            offset = space
        case .center(let space):
            offset = space / 2
        }
        switch self.scrollDirection {
        case .horizontal:
            return self.view.right + offset
        case .vertical:
            return self.view.bottom + offset
        }
    }
//    public func trailing(isLast: Bool) -> CGFloat {
//        if isLast {
//            switch self.itemSpace {
//            case .leading(let space):
//                return self.trailing - space
//            case .center:
//                return self.trailing
//            }
//        } else {
//            return self.trailing
//        }
//    }

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
