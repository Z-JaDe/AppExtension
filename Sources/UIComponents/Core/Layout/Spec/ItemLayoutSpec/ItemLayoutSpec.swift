//
//  ItemLayoutSpec.swift
//  Third
//
//  Created by ZJaDe on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

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
}
