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
        var array: [Constraint] = []
        self.forEach { (item) in
            array += item.snp.prepareConstraints({ (maker) in
                closure(item, maker)
            })
        }
        return array
    }

    public func makeConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) {
        self.forEach { (item) in
            item.snp.makeConstraints({ (maker) in
                closure(item, maker)
            })
        }
    }

    public func remakeConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) {
        self.forEach { (item) in
            item.snp.remakeConstraints({ (maker) in
                closure(item, maker)
            })
        }
    }

    public func updateConstraints(_ closure: (_ item: Element, _ make: ConstraintMaker) -> Void) {
        self.forEach { (item) in
            item.snp.updateConstraints({ (maker) in
                closure(item, maker)
            })
        }
    }

    public func removeConstraints() {
        self.forEach { (item) in
            item.snp.removeConstraints()
        }
    }
}
