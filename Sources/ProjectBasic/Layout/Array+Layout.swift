////
////  Array+Layout.swift
////  ZiWoYou
////
////  Created by ZJaDe on 16/12/14.
////  Copyright © 2016年 Z_JaDe. All rights reserved.
////

import UIKit
import SnapKit

extension Array where Element: UIView {
    @discardableResult
    public func prepareConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) -> [Constraint] {
        return reduce(into: [Constraint]()) { (result, item) in
            result += item.snp.prepareConstraints({ closure(item, $0) })
        }
    }

    public func makeConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) {
        forEach { (item) in
            item.snp.makeConstraints({ closure(item, $0) })
        }
    }

    public func remakeConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) {
        forEach { (item) in
            item.snp.remakeConstraints({ closure(item, $0) })
        }

    }

    public func updateConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) {
        forEach { (item) in
            item.snp.updateConstraints({ closure(item, $0) })
        }
    }

    public func removeConstraints() {
        forEach { $0.snp.removeConstraints() }
    }
}
