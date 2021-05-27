//
//  Core.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/10/19.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

#if !AppExtensionPods
@_exported import Async
#endif

public func measure(closure: () -> Void) {
    let start = CACurrentMediaTime()
    closure()
    let end = CACurrentMediaTime()
    print("测量时间：\(end - start)")
}
