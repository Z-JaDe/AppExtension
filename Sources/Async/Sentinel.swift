//
//  Sentinel.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/10.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct Sentinel {
    public init() {}
    private var _value: Int32 = 0

    public var value: Int32 { _value }
    @discardableResult
    public mutating func increase() -> Int32 {
        OSAtomicIncrement32(&_value)
    }
}
