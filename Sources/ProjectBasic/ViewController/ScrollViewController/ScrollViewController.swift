//
//  ScrollViewController.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import UIKit

open class ScrollViewController<ScrollViewType>: GenericsViewController<ScrollViewType> where ScrollViewType: UIScrollView {
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
}

open class SNScrollViewContorller: ScrollViewController<ScrollView> {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.rootView.alwaysBounceVertical = true
    }
}
