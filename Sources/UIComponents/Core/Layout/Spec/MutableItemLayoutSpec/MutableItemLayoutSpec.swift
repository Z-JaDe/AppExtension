//
//  MutableItemLayoutSpec.swift
//  Third
//
//  Created by ZJaDe on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

open class MutableItemLayoutSpec: LayoutSpec {
    public let childArr: [LayoutElement]
    public init(_ childArr: [LayoutElement]) {
        self.childArr = childArr
        super.init()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    override func addChild() {
        self.childArr.forEach { (child) in
            if child.superview == nil {
                self.addSubview(child)
            }
        }
    }
}
