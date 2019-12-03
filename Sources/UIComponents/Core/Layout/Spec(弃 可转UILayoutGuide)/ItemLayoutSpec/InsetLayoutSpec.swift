//
//  InsetLayoutSpec.swift
//  Third
//
//  Created by ZJaDe on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

open class InsetLayoutSpec: RelativeLayoutSpec {
    public convenience init(_ child: LayoutElement, _ inset: UIEdgeInsets, _ sizingOptions: LayoutSpecSizingOptions) {
        self.init(child, sizingOptions)
        self.set(inset)
        setNeedUpdateLayout()
    }

    func set(_ inset: UIEdgeInsets) {
        self.horizontal = .fill(inset.left, inset.right)
        self.vertical = .fill(inset.top, inset.bottom)
    }
}
extension LayoutElement {
    public func insetSpec(_ inset: UIEdgeInsets, _ sizingOptions: LayoutSpecSizingOptions = .default) -> InsetLayoutSpec {
        if let spec = self.superview as? InsetLayoutSpec {
            spec.set(inset)
            spec.sizingOptions = sizingOptions
            return spec
        } else {
            return InsetLayoutSpec(self, inset, sizingOptions)
        }
    }
}
