//
//  SegmentedControl.swift
//  SNKit_TJS
//
//  Created by 苏义坤 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit
open class SegmentedControl: UISegmentedControl {

    public override init(items: [Any]? = nil) {
        super.init(items: items)
        configInit()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
    }
}
