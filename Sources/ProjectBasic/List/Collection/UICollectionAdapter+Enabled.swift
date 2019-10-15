//
//  UICollectionAdapter+Enabled.swift
//  ProjectBasic
//
//  Created by ZJaDe on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension UICollectionAdapter {
    public func updateEnabledState(_ isEnabled: Bool) {
        dataArray.lazy.flatMap({$0.items}).forEach { (item) in
            item.refreshEnabledState(isEnabled)
        }
    }
}
