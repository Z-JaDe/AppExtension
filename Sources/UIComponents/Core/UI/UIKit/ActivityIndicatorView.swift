//
//  ActivityIndicatorView.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ActivityIndicatorView: UIActivityIndicatorView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configInit()
    }

    required public init(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }

    open func configInit() {
    }
}
