//
//  ConstraintMaker.swift
//  Third
//
//  Created by ZJaDe on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import SnapKit

extension ConstraintMaker {
    @discardableResult
    public func horizontal(_ other: ConstraintRelatableTarget, _ position: LayoutOptions) -> ConstraintMakerEditable {
        switch position {
        case .start(let offset):
            return self.left.equalTo(other).offset(offset)
        case .centerOffset(let offset):
            return self.centerX.equalTo(other).offset(offset)
        case .end(let offset):
            return self.right.equalTo(other).offset(-offset)
        case .fill(let left, let right):
            return self.left.right.equalTo(other).inset(UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
        }
    }
    @discardableResult
    public func vertical(_ other: ConstraintRelatableTarget, _ position: LayoutOptions) -> ConstraintMakerEditable {
        switch position {
        case .start(let offset):
            return self.top.equalTo(other).offset(offset)
        case .centerOffset(let offset):
            return self.centerY.equalTo(other).offset(offset)
        case .end(let offset):
            return self.bottom.equalTo(other).offset(-offset)
        case .fill(let top, let bottom):
            return self.top.bottom.equalTo(other).inset(UIEdgeInsets(top: top, left: 0, bottom: bottom, right: 0))

        }
    }
}
