//
//  RelativeLayoutSpec.swift
//  Third
//
//  Created by ZJaDe on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

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

    open override func layoutArr() -> [NSLayoutConstraint] {
        super.layoutArr()
            + layoutHorizontal()
            + layoutVertical()
    }
    func layoutHorizontal() -> [NSLayoutConstraint] {
        var array: [NSLayoutConstraint] = []
        switch self.horizontal {
        case .none:
            return array
        case .start(let offset):
            array += child.horizontal(self, .start(offset))
            array.append(contentsOf: child.innerTo(view: self, .right))
        case .centerOffset(let offset):
            array += child.horizontal(self, .centerOffset(offset))
            array.append(contentsOf: child.innerTo(view: self, [.left, .right]))
        case .centerInset(let inset):
            array += child.horizontal(self, .centerOffset(0))
            array += child.horizontal(self, .start(inset))
        case .end(let offset):
            array += child.horizontal(self, .end(offset))
            array.append(contentsOf: child.innerTo(view: self, [.left]))
        case .fill(let left, let right):
            array += child.horizontal(self, .fill(left, right))
        }
        return array
    }
    func layoutVertical() -> [NSLayoutConstraint] {
        var array: [NSLayoutConstraint] = []
        switch self.vertical {
        case .none:
            return array
        case .start(let offset):
            array += child.vertical(self, .start(offset))
            array.append(contentsOf: child.innerTo(view: self, [.bottom]))
        case .centerOffset(let offset):
            array += child.vertical(self, .centerOffset(offset))
            array.append(contentsOf: child.innerTo(view: self, [.top, .bottom]))
        case .centerInset(let inset):
            array += child.vertical(self, .centerOffset(0))
            array += child.vertical(self, .start(inset))
        case .end(let offset):
            array += child.vertical(self, .end(offset))
            array.append(contentsOf: child.innerTo(view: self, [.top]))
        case .fill(let top, let bottom):
            array += child.vertical(self, .fill(top, bottom))
        }
        return array
    }
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
