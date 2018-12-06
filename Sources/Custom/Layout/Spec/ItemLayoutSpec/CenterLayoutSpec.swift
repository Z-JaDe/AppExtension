//
//  CenterLayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

public enum LayoutSpecCenteringOptions {
    case none
    case X
    case Y
    case XY
}

open class CenterLayoutSpec: RelativeLayoutSpec {
    public convenience init(_ child: LayoutElement, _ centeringOptions: LayoutSpecCenteringOptions, _ sizingOptions: LayoutSpecSizingOptions) {
        self.init(child, sizingOptions)
        self.set(centeringOptions)
        setNeedUpdateLayout()
    }

    func set(_ centeringOptions: LayoutSpecCenteringOptions) {
        switch centeringOptions {
        case .none:
            self.horizontal = .none
            self.vertical = .none
        case .X:
            self.horizontal = .centerOffset(0)
        case .Y:
            self.vertical = .centerOffset(0)
        case .XY:
            self.horizontal = .centerOffset(0)
            self.vertical = .centerOffset(0)
        }
    }
}
extension LayoutElement {
    public func centerSpec(_ centeringOptions: LayoutSpecCenteringOptions, _ sizingOptions: LayoutSpecSizingOptions = .default) -> CenterLayoutSpec {
        if let spec = self.superview as? CenterLayoutSpec {
            spec.set(centeringOptions)
            spec.sizingOptions = sizingOptions
            return spec
        } else {
            return CenterLayoutSpec(self, centeringOptions, sizingOptions)
        }
    }
}
