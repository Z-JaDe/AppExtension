//
//  CornerLayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public enum CornerLayoutLocation {
    case topLeft(CGFloat, CGFloat)
    case topRight(CGFloat, CGFloat)
    case bottomLeft(CGFloat, CGFloat)
    case bottomRight(CGFloat, CGFloat)

    case topFill(CGFloat, CGFloat)
    case bottomFill(CGFloat, CGFloat)
    case leftFill(CGFloat, CGFloat)
    case rightFill(CGFloat, CGFloat)
}

open class CornerLayoutSpec: RelativeLayoutSpec {
    public convenience init(_ child: LayoutElement, _ cornerLayoutLocation: CornerLayoutLocation, _ sizingOptions: LayoutSpecSizingOptions) {
        self.init(child, sizingOptions)
        self.set(cornerLayoutLocation)
        setNeedUpdateLayout()
    }

    func set(_ cornerLayoutLocation: CornerLayoutLocation) {
        switch cornerLayoutLocation {
        case .topLeft(let top, let left):
            self.horizontal = .start(top)
            self.vertical = .start(left)
        case .topRight(let top, let right):
            self.horizontal = .end(right)
            self.vertical = .start(top)
        case .bottomLeft(let bottom, let left):
            self.horizontal = .start(left)
            self.vertical = .end(bottom)
        case .bottomRight(let bottom, let right):
            self.horizontal = .end(bottom)
            self.vertical = .end(right)

        case .topFill(let offSet, let fillOffset):
            self.horizontal = .fill(fillOffset, fillOffset)
            self.vertical = .start(offSet)
        case .bottomFill(let offSet, let fillOffset):
            self.horizontal = .fill(fillOffset, fillOffset)
            self.vertical = .end(offSet)
        case .leftFill(let offSet, let fillOffset):
            self.horizontal = .start(offSet)
            self.vertical = .fill(fillOffset, fillOffset)
        case .rightFill(let offSet, let fillOffset):
            self.horizontal = .end(offSet)
            self.vertical = .fill(fillOffset, fillOffset)
        }
    }
}
extension LayoutElement {
    public func cornerSpec(_ cornerLayoutLocation: CornerLayoutLocation, _ sizingOptions: LayoutSpecSizingOptions = .default) -> CornerLayoutSpec {
        if let spec = self.superview as? CornerLayoutSpec {
            spec.set(cornerLayoutLocation)
            spec.sizingOptions = sizingOptions
            return spec
        } else {
            return CornerLayoutSpec(self, cornerLayoutLocation, sizingOptions)
        }
    }
}
