//
//  LayoutSpec.swift
//  Third
//
//  Created by 郑军铎 on 2018/6/15.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit

public typealias LayoutElement = UIView

open class LayoutSpec: UIView {

    public init() {
        super.init(frame: CGRect.zero)
        self.configInit()
        self.viewDidLoad()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
        self.backgroundColor = Color.clear
    }
    open func viewDidLoad() {
        addChild()
        updateLayout()
    }
    public final func setNeedUpdateLayout() {
        self.updateLayout()
    }
    internal func addChild() {}
    internal func updateLayout() {
        var constraintArr: [NSLayoutConstraint] = []
        constraintArr += layoutArr()
        self.updateLayouts(tag: "layoutArr", constraintArr)
    }
    open func layoutArr() -> [NSLayoutConstraint] {
        return []
    }
}
