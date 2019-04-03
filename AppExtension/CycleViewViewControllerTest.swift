//
//  CycleViewViewControllerTest.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/26.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import UIKit
import ScrollExtensions

class CycleViewViewControllerTest: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
        segmentView.clipsToBounds = false
        segmentView.addBorder(width: 1, color: Color.red)
        
        segmentView.scrollView.then { (segmentScrollView) in
            segmentScrollView.itemSpace = .center(10)
            segmentScrollView.clipsToBounds = false
        }
        segmentView.configData(["1", "2", "3", "4", "5", "6", "7", "8", "9"])
        segmentView.pageControl.isHidden = true
        self.view.addSubview(segmentView)
        segmentView.snp.makeConstraints { (maker) in
            maker.left.equalTo(125)
            maker.top.equalTo(300)
            maker.width.equalTo(100)
//            maker.height.equalTo(80)
        }
        
    }
    
    let segmentView: CycleView<ItemView, String> = {
        let segment = CycleView<ItemView, String>()
        segment.viewUpdater = { (itemView, data, _) in
            itemView.label.text = "\(data)"
            Async.main(after: 1, {
                //            label.superview?.superview?.setNeedsLayout()
            })
        }
        return segment
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logDebug("\(String(describing: self.index)) 将要出现")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logDebug("\(String(describing: self.index)) 已经出现")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logDebug("\(String(describing: self.index)) 将要消失")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logDebug("\(String(describing: self.index)) 已经消失")
    }
}
class ItemView: CustomView {
    let label: Label = Label()
    override func configInit() {
        super.configInit()
        label.addBorder(color: Color.boderLine)
        label.textColor = Color.white
        label.backgroundColor = UIColor.randomColor()
        label.textAlignment = .center
    }
    override func addChildView() {
        super.addChildView()
        self.addSubview(self.label)
    }
    override func configLayout() {
        super.configLayout()
        self.label.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
//            maker.height.equalTo(100)
        }
    }
}
