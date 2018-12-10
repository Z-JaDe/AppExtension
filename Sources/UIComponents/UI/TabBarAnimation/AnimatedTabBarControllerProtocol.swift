//
//  AnimatedTabBarControllerProtocol.swift
//  JDAnimatedTabBarControllerDemo
//
//  Created by 茶古电子商务 on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import UIKit
public protocol AnimatedTabBarControllerProtocol {
    var jdTabBar: TabBar {get}
    func configAnimatedTabbar()
}
public extension AnimatedTabBarControllerProtocol where Self: UITabBarController {
    func configAnimatedTabbar() {
        self.setValue(jdTabBar, forKey: "tabBar")
    }
}
