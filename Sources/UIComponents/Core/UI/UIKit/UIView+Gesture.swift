//
//  UIView.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/19.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

private var jd_panKey: UInt8 = 0
private var jd_tapKey: UInt8 = 0
extension UIView {
    public var panGesture: UIPanGestureRecognizer {
        associatedObject(&jd_panKey, createIfNeed: {() -> UIPanGestureRecognizer in
            let pan = UIPanGestureRecognizer()
            self.addGestureRecognizer(pan)
            return pan
        }())
    }
    public var tapGesture: UITapGestureRecognizer {
        associatedObject(&jd_tapKey, createIfNeed: {() -> UITapGestureRecognizer in
            let tap = UITapGestureRecognizer()
            self.addGestureRecognizer(tap)
            return tap
        }())
    }
}
