//
//  NavigationBar.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/26.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import UIKit

open class NavigationBar: UINavigationBar {
    open override func value(forUndefinedKey key: String) -> Any? {
        logError("NavigationBar找不到key->\(key)")
        return nil
    }
}
extension UINavigationBar {
    public var jd_backgroundView: UIView? {
        let keyStr: String
        if #available(iOS 10.0, *) {
            keyStr = "_backgroundView._backgroundEffectView"
        } else {
            keyStr = "_backgroundView"
        }
        return self.value(forKeyPath: keyStr) as? UIView
    }
}
