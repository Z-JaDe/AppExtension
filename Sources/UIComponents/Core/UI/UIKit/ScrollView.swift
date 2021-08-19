//
//  ScrollView.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ScrollView: UIScrollView {

    public override init(frame: CGRect = CGRect.zero) {
        super.init(frame: frame)
        configInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
        self.backgroundColor = UIColor.clear
    }
}
