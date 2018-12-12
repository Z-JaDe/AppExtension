//
//  List.swift
//  List
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

#if !AppExtensionPods
@_exported import ProjectBasic
@_exported import Core
@_exported import UIComponents
@_exported import EmptyDataSet
@_exported import Animater
#endif

@inline(__always)
func assertMainThread() {
    assert(Thread.isMainThread, "You must call on MainThread")
}
