//
//  ScrollViewController.swift
//  SNKit_TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ScrollViewContorller: GenericsViewController<ScrollView> {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.alwaysBounceVertical = true
    }
}
