//
//  FontViewControllerTest.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/12.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import UIKit
import CocoaExtension
import Custom
class FontViewControllerTest: UIViewController {
    var observer: NotificationToken?
    var kvoObserver: NSKeyValueObservation?
    override func viewDidLoad() {
        super.viewDidLoad()
        observer = NotificationCenter.default.observe(name: jd.detectScreenShotNotification, object: nil, queue: nil) { (_) in
            print("\(self)")
        }
        kvoObserver = self.observe(\.view.frame, changeHandler: { (_, _) in
            print("\(self.view.frame)")
        })
        testFontTextStyle()
    }
    
    // MARK: 测试 preferredFont
    func testFontTextStyle() {
        
        self.addFontLabelWithTextStyle(style: .title1)
        self.addFontLabelWithTextStyle(style: .title2)
        self.addFontLabelWithTextStyle(style: .title3)
        self.addFontLabelWithTextStyle(style: .headline)
        self.addFontLabelWithTextStyle(style: .subheadline)
        self.addFontLabelWithTextStyle(style: .body)
        self.addFontLabelWithTextStyle(style: .callout)
        self.addFontLabelWithTextStyle(style: .footnote)
        self.addFontLabelWithTextStyle(style: .caption1)
        self.addFontLabelWithTextStyle(style: .caption2)
        
    }
    // 添加label
    var textStyleIndex: Int = 0
    func addFontLabelWithTextStyle(style: UIFont.TextStyle) {
        
        let label = UILabel.init(frame: CGRect(x: 10, y: 100 + self.textStyleIndex * 40, width: 400, height: 20))
        let font = UIFont.init(name: "PingFangSC-Regular", size: CGFloat(self.textStyleIndex + 10))!
        label.font = font
        label.text = "\(style.rawValue)" + " \(font.pointSize)"
        self.view.addSubview(label)
        
        self.textStyleIndex += 1
    }
}
