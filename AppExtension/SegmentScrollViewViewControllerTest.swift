//
//  SegmentScrollViewViewControllerTest.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/6/26.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import UIKit
import Custom
class SegmentScrollViewViewControllerTest: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.white
        segmentView.origin = CGPoint(x: 150, y: 300)
        segmentView.height = 40
        segmentView.width = 50
        segmentView.clipsToBounds = false
        segmentView.addBorder(width: 1, color: Color.red)
        
        segmentView.then { (segmentScrollView) in
            segmentScrollView.itemSpace = .center(10)
            segmentScrollView.clipsToBounds = false
        }
        for _ in 0...5 {
            segmentView.insertAndUpdate(createItemView(), at: 0)
        }
        
        self.view.addSubview(segmentView)
        
    }
    
    let segmentView: SegmentScrollView<UILabel> = {
        let segment = SegmentScrollView<UILabel>()
        return segment
    }()
    func createItemView(_ text: String = "啊") -> UILabel {
        let view = UILabel()
        view.addBorder(color: Color.boderLine)
        view.backgroundColor = UIColor.randomColor()
        view.text = "\(text)"
        return view
    }
}
