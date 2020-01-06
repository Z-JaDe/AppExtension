//
//  AssociatedObjectProtocol.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/5.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

private final class WarppedObject {
    var target: Any?
    init(_ target: Any?) {
        self.target = target
    }
}
private final class WeakWarppedObject {
    weak var target: AnyObject?
    init(_ target: AnyObject?) {
        self.target = target
    }
}
public protocol AssociatedObjectProtocol: class {
    // MARK: - get
    /// ZJaDe: V的类型不能是协议 或者部分协议，要不然取值的时候会转换成nil
    func associatedObject<V>(_ key: UnsafeRawPointer) -> V?
    func associatedObject<V>(_ key: UnsafeRawPointer, createIfNeed closure: @autoclosure () -> V) -> V
    // MARK: - set
    func setAssociatedObject<V>(_ key: UnsafeRawPointer, _ newValue: V?)
    func setAssociatedWeakObject<V: AnyObject>(_ key: UnsafeRawPointer, _ newValue: V?)
}
public extension AssociatedObjectProtocol {
    // MARK: - get
    func associatedObject<V>(_ key: UnsafeRawPointer) -> V? {
        _associatedObject(key)
    }
    func associatedObject<V>(_ key: UnsafeRawPointer, createIfNeed closure: @autoclosure () -> V) -> V {
        if let value: V = associatedObject(key) {
            return value
        } else {
            let value: V = closure()
            setAssociatedObject(key, value)
            return value
        }
    }
    // MARK: - set
    func setAssociatedObject<V>(_ key: UnsafeRawPointer, _ newValue: V?) {
        if V.self is AnyClass {
            _setAssociatedObject(key, newValue)
        } else {
            _setAssociatedObject(key, WarppedObject(newValue))
        }
    }
    func setAssociatedWeakObject<V: AnyObject>(_ key: UnsafeRawPointer, _ newValue: V?) {
        _setAssociatedObject(key, WeakWarppedObject(newValue))
    }
}
private extension AssociatedObjectProtocol {
    func _associatedObject<V>(_ key: UnsafeRawPointer) -> V? {
        let value = objc_getAssociatedObject(self, key)
        if let value = value as? WarppedObject {
            return value.target as? V
        } else if let value = value as? WeakWarppedObject {
            return value.target as? V
        }
        return value as? V
    }
    func _setAssociatedObject<V>(_ key: UnsafeRawPointer, _ newValue: V?) {
        objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
}
extension NSObject: AssociatedObjectProtocol {}
