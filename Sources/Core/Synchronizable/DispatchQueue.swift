//
//  DispatchQueue.swift
//  AppExtension
//
//  Created by Apple on 2019/4/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public func performInMainAsync(_ action: @escaping () -> Void) {
    if Thread.isMainThread {
        return action()
    } else {
        return DispatchQueue.main.async(execute: action)
    }
}

private let labelSpec = DispatchSpecificKey<Int>()
extension DispatchQueue {
    public func syncIfNeed<T>(_ action: () throws -> T) rethrows -> T {
        if Thread.isMainThread && self == DispatchQueue.main {
            return try action()
        }
        let label = Int.random(min: 0, max: 1000)
        setSpecific(key: labelSpec, value: label)
        if let label = DispatchQueue.getSpecific(key: labelSpec), label == label {
            setSpecific(key: labelSpec, value: nil)
            return try action()
        } else {
            return try sync(execute: action)
        }
    }
    public func syncInMain<T>(_ action: () throws -> T) rethrows -> T {
        return try sync {
            return try DispatchQueue.main.syncIfNeed(action)
        }
    }
}
