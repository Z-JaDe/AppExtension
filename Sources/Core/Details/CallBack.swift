//
//  CallBack.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public typealias CallBackNoParams = () -> Void
public typealias CallBack<Params> = (Params) -> Void

public typealias CallBackerNoParams = CallBacker<(), ()>
public typealias CallBackerVoid<Input> = CallBacker<Input, ()>
public typealias CallBackerReduce<Input> = CallBacker<Input, Input>
public class CallBacker<Input, Output> {
    typealias ClosureType = (Input) -> Output?
    private var closures: [String: ClosureType] = [:]
    private var keys: [String] = []
    private let defaultKey: String = "__default"
    private let queue: DispatchQueue = DispatchQueue(label: "com.zjade.callBacker")
    public init() {}

    private func _register<T: AnyObject>(on target: T, key: String, closure: ((T, Input) -> Output)?) {
        queue.async {
            self.keys.removeAll(where: {$0 == key})
            if let closure = closure {
                self.keys.append(key)
                self.closures[key] = { [weak target] (input) in
                    guard let target = target else { return nil }
                    return closure(target, input)
                }
            } else {
                self.closures[key] = nil
            }
        }
    }

    public func cleanAll() {
        queue.async {
            self.keys.removeAll()
            self.closures.removeAll()
        }
    }
}
// MARK: -
extension CallBacker {
    public func register<T: AnyObject>(on target: T, _ closure: ((T, Input) -> Output)?) {
        self._register(on: target, key: self.defaultKey, closure: closure)
    }
    public func register<T: AnyObject>(on target: T, key: String, _ closure: ((T, Input) -> Output)?) {
        self._register(on: target, key: key, closure: closure)
    }
    public func callAll(_ input: Input) -> [Output] {
        queue.syncInMain {
            var result: [Output] = []
            for key in self.keys {
                if let output = self.closures[key]?(input) {
                    result.append(output)
                }
            }
            return result
        }
    }
    public func callOne(_ input: Input) -> Output? {
        queue.syncInMain {
            if let closure = self.closures[self.defaultKey] {
                return closure(input)
            } else {
                return nil
            }
        }
    }
}
// MARK: -
extension CallBacker where Input == Output {
    public func callReduce(_ input: Input) -> Output {
        queue.syncInMain {
            var result: Output = input
            for key in self.keys {
                if let output = self.closures[key]?(result) {
                    result = output
                }
            }
            return result
        }
    }
}
// MARK: -
extension CallBacker where Input == Void {
    public func callOne() -> Output? {
        self.callOne(())
    }
}
// MARK: -
extension CallBacker where Output == Void {
    public func register<T: AnyObject>(on target: T, key: String, _ closure: ((T, Input) -> Void)?) {
        self._register(on: target, key: key, closure: closure)
    }
    public func call(_ input: Input) {
        queue.async {
            DispatchQueue.main.syncIfNeed {
                for key in self.keys {
                    self.closures[key]?(input)
                }
            }
        }
    }
}
// MARK: -
extension CallBacker where Input == Void, Output == Void {
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
