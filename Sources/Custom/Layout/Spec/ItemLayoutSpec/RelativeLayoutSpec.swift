//
//  RelativeLayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import SnapKit

public enum RelativeLayoutSpecOptions {
    case none
    case start(CGFloat)
    case centerOffset(CGFloat)
    case centerInset(CGFloat)
    case end(CGFloat)
    case fill(CGFloat, CGFloat)
}

open class RelativeLayoutSpec: SizeLayoutSpec {
    internal var horizontal: RelativeLayoutSpecOptions = .none {
        didSet {setNeedUpdateLayout()}
    }
    internal var vertical: RelativeLayoutSpecOptions = .none {
        didSet {setNeedUpdateLayout()}
    }
    public convenience init(_ child: LayoutElement, _ horizontal: RelativeLayoutSpecOptions, _ vertical: RelativeLayoutSpecOptions, _ sizingOptions: LayoutSpecSizingOptions) {
        self.init(child, sizingOptions)
        self.horizontal = horizontal
        self.vertical = vertical
        setNeedUpdateLayout()
    }

    open override func layout(_ maker: ConstraintMaker) {
        super.layout(maker)
        layoutHorizontal(maker)
        layoutVertical(maker)
    }
    func layoutHorizontal(_ maker: ConstraintMaker) {
        switch self.horizontal {
        case .none:
            return
        case .start(let offset):
            maker.horizontal(self, .start(offset))
            maker.right.lessThanOrEqualTo(self)
        case .centerOffset(let offset):
            maker.horizontal(self, .centerOffset(offset))
            maker.left.greaterThanOrEqualTo(self)
            maker.right.lessThanOrEqualTo(self)
        case .centerInset(let inset):
            maker.horizontal(self, .centerOffset(0))
            maker.horizontal(self, .start(inset))
        case .end(let offset):
            maker.horizontal(self, .end(offset))
            maker.left.greaterThanOrEqualTo(self)
        case .fill(let left, let right):
            maker.horizontal(self, .fill(left, right))
        }
    }
    func layoutVertical(_ maker: ConstraintMaker) {
        switch self.vertical {
        case .none:
            return
        case .start(let offset):
            maker.vertical(self, .start(offset))
            maker.bottom.lessThanOrEqualTo(self)
        case .centerOffset(let offset):
            maker.vertical(self, .centerOffset(offset))
            maker.top.greaterThanOrEqualTo(self)
            maker.bottom.lessThanOrEqualTo(self)
        case .centerInset(let inset):
            maker.vertical(self, .centerOffset(0))
            maker.vertical(self, .start(inset))
        case .end(let offset):
            maker.vertical(self, .end(offset))
            maker.top.greaterThanOrEqualTo(self)
        case .fill(let top, let bottom):
            maker.vertical(self, .fill(top, bottom))
        }
    }

//    private func makerOption(_ layoutOption: RelativeLayoutSpecOptions) -> MakerLayoutOptions? {
//        switch layoutOption {
//        case .none: 
//            return nil
//        case .start(let offset): return .start(offset)
//        case .center(let offset): return .center(offset)
//        case .end(let offset): return .end(offset)
//        case .fill(let inset): return .fill(inset.0, inset.1)
//        }
//    }
}

extension LayoutElement {
    public func relativeSpec(_ horizontal: RelativeLayoutSpecOptions, _ vertical: RelativeLayoutSpecOptions, _ sizingOptions: LayoutSpecSizingOptions = .default) -> RelativeLayoutSpec {
        if let spec = self.superview as? RelativeLayoutSpec {
            spec.sizingOptions = sizingOptions
            spec.horizontal = horizontal
            spec.vertical = vertical
            return spec
        } else {
            return RelativeLayoutSpec(self, horizontal, vertical, sizingOptions)
        }
    }
}
