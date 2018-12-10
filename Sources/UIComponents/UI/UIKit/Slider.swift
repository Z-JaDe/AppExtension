//
//  Slider.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/4.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

import UIKit

open class Slider: UISlider {
    public var tractHeight: CGFloat = 2

    open override func trackRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: (bounds.size.height-tractHeight)/2, width: bounds.size.width, height: tractHeight)
    }
}
