//
//  List.swift
//  List
//
//  Created by ZJaDe on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

#if !AppExtensionPods
@_exported import Core
#endif

@inline(__always)
func assertMainThread() {
    assert(Thread.isMainThread, "You must call on MainThread")
}
