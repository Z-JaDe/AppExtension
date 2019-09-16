//
//  UITableAdapter+Enabled.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension UITableAdapter: EnabledStateDesignable {
    public func updateEnabledState(_ isEnabled: Bool) {
        dataArray.flatMap({$0.items}).forEach { (item) in
            (item.value as? EnabledStateDesignable)?.refreshEnabledState(isEnabled)
        }
    }
}
