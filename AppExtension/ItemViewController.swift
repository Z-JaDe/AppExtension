//
//  ItemViewController.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/26.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import Custom
class ItemViewController: UIViewController {
    var index: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(UILabel().then({ (label) in
            label.text = "界\(index)"
            label.font = Font.systemFontOfSize(50)
            label.sizeToFit()
            label.centerX = jd.screenWidth / 2
            label.centerY = jd.screenHeight / 2
        }))
        self.view.backgroundColor = UIColor.randomColor()
        logDebug("\(self.index) 加载")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logDebug("\(self.index) 将要出现")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logDebug("\(self.index) 已经出现")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logDebug("\(self.index) 将要消失")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logDebug("\(self.index) 已经消失")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
