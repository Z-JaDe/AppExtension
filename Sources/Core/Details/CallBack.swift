//
//  CallBack.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public typealias CallBackNoParams = () -> Void
public typealias CallBack<Params> = (Params) -> Void

public typealias CallBackerNoParams = Callbacker<(), ()>
public typealias CallBackerVoid<Input> = Callbacker<Input, ()>
public class Callbacker<Input, Output> {
    typealias ClosureType = (Input) -> Output?
    private var closures: [String: ClosureType] = [:]
    private let defaultKey: String = "__default"
    public init() {}

    private func _register<T: AnyObject>(on target: T, key: String, closure: ((T, Input) -> Output)?) {
        if let closure = closure {
            self.closures[key] = { [weak target] (input) in
                guard let target = target else { return nil }
                return closure(target, input)
            }
        } else {
            self.closures[key] = nil
        }
    }
    public func register<T: AnyObject>(on target: T, _ closure: ((T, Input) -> Output)?) {
        self._register(on: target, key: self.defaultKey, closure: closure)
    }
    public func cleanAll() {
        self.closures.removeAll()
    }
    public func call(_ input: Input) -> Output? {
        let closure = self.closures[self.defaultKey]
        return closure?(input)
    }
}
extension Callbacker where Output == Void {
    public func register<T: AnyObject>(on target: T, key: String, _ closure: ((T, Input) -> Void)?) {
        self._register(on: target, key: key, closure: closure)
    }
    public func call(_ input: Input) {
        for closure in self.closures.values {
            closure(input)
        }
    }
}

extension Callbacker where Input == Void, Output == Void {
    public func register<T: AnyObject>(on target: T, _ closure: ((T) -> Void)?) {
        self.register(on: target, key: self.defaultKey, closure)
    }
    public func register<T: AnyObject>(on target: T, key: String, _ closure: ((T) -> Void)?) {
        if let closure = closure {
            self._register(on: target, key: key, closure: { (target, _) in closure(target) })
        } else {
            self._register(on: target, key: key, closure: nil)
        }
    }
    public func call() {
        self.call(())
    }
}
