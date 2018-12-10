//
//  Sentinel.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/10.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public class Sentinel {
    public init() {}
    private var _value: Int32 = 0

    public var value: Int32 {
        return _value
    }
    @discardableResult
    public func increase() -> Int32 {
        return OSAtomicIncrement32(&_value)
    }
}
