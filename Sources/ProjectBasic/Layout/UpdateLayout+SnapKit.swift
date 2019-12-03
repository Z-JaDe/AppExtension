//
//  UpdateLayout+SnapKit.swift
//  AppExtension
//
//  Created by Apple on 2019/5/23.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import SnapKit

extension Constraint: ConstraintProtocol {}
extension UIView {
    public var snLayout: UpdateLayout<Constraint> {
        UpdateLayout(view: self)
    }
    public func updateLayouts(tag: String? = nil, _ closure: @autoclosure () -> ([Constraint])) {
        snLayout.updateLayouts(tag: tag, closure())
    }
    public func updateLayoutsMaker(tag: String? = nil, _ closure: (ConstraintMaker) -> Void) {
        updateLayouts(tag: tag, snp.prepareConstraints(closure))
    }
}
