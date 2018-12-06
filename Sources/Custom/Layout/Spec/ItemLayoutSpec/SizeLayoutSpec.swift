//
//  SizeLayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public enum LayoutSpecSizingOptions {
    case `default`
    case minimumWidth
    case minimumHeight
    case minimumSize
}

open class SizeLayoutSpec: ItemLayoutSpec {
    internal var sizingOptions: LayoutSpecSizingOptions = .minimumSize {
        didSet {layoutSizing()}
    }
    public convenience init(_ child: LayoutElement, _ sizingOptions: LayoutSpecSizingOptions) {
        self.init(child)
        self.sizingOptions = sizingOptions
    }
    override func updateLayout() {
        super.updateLayout()
        layoutSizing()
    }
    func layoutSizing() {
        switch self.sizingOptions {
        case .default:
            break
        case .minimumHeight:
            self.child.contentHuggingVerticalPriority = .required
        case .minimumWidth:
            self.child.contentHuggingHorizontalPriority = .required
        case .minimumSize:
            self.child.contentHuggingPriority(.required)
        }
    }
}
