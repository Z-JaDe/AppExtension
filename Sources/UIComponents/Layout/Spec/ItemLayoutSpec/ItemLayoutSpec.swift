//
//  ItemLayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import SnapKit
open class ItemLayoutSpec: LayoutSpec {
    public let child: LayoutElement
    public init(_ child: LayoutElement) {
        self.child = child
        super.init()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    override func addChild() {
        if self.child.superview == nil {
            self.addSubview(self.child)
        }
    }

    open override func layoutArr() -> [Constraint] {
        return super.layoutArr() + self.child.snp.prepareConstraints({ (maker) in
            layout(maker)
        })
    }
    open func layout(_ maker: ConstraintMaker) {

    }
}
