//
//  NSLayoutConstraint.swift
//  AppExtension
//
//  Created by Apple on 2019/5/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension NSLayoutConstraint {
    public static func equal(item view1: Any, toItem view2: Any?, attribute: Attribute, constant: CGFloat = 0) -> NSLayoutConstraint {
        NSLayoutConstraint(item: view1, attribute: attribute, relatedBy: .equal, toItem: view2, attribute: attribute, multiplier: 1, constant: constant)
    }
    public func changePriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
