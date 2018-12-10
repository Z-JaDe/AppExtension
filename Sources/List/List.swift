//
//  List.swift
//  List
//
//  Created by 郑军铎 on 2018/6/7.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation

#if !AppExtensionPods
@_exported import Core
@_exported import Third
@_exported import UIComponents
@_exported import EmptyDataSet
@_exported import Animater
#endif

enum RxDataSourceError: Error {
    case preconditionFailed(message: String)
}

func rxPrecondition(_ condition: Bool, _ message: @autoclosure() -> String) throws {
    if condition {
        return
    }
    rxDebugFatalError("Precondition failed")

    throw RxDataSourceError.preconditionFailed(message: message())
}

func rxDebugFatalError(_ error: Error) {
    rxDebugFatalError("\(error)")
}

func rxDebugFatalError(_ message: String) {
    #if DEBUG
    fatalError(message)
    #else
    print(message)
    #endif
}

@inline(__always)
func assertMainThread() {
    assert(Thread.isMainThread, "You must call on MainThread")
}
