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
extension DispatchQueue {
    public var isInCurrentQueue: Bool {
        let labelSpec = DispatchSpecificKey<()>()
        setSpecific(key: labelSpec, value: ())
        if DispatchQueue.getSpecific(key: labelSpec) != nil {
            setSpecific(key: labelSpec, value: nil)
            return true
        } else {
            return false
        }
    }
    /**
        若当前在队列执行的任务代码中，会直接执行，否则会添加sync任务
        须注意若队列的targetQueue为main队列，且当前是主线程时，这里还是会崩溃
        是因为api没有提供查询当前队列的targetQueue是什么队列
     */
    public func syncIfNeed<T>(_ action: () throws -> T) rethrows -> T {
        if self == DispatchQueue.main && Thread.isMainThread {
            //self是main队列且在主线程时，可以直接执行action。即使当前是在其他队列的任务代码中，也不影响。
            return try action()
        }
        if self.isInCurrentQueue {
            //当前是在self队列的任务代码执行中时，可以直接执行action。
            return try action()
        } else {
            return try sync(execute: action)
        }
    }
    /**
        同步执行任务，任务会在主线程同步执行返回，需注意sync在串行队列中可能存在的崩溃问题
     */
    public func syncInMain<T>(_ action: () throws -> T) rethrows -> T {
        //这里不直接判断是否在主线程，是因为在这里sync语义,除了阻塞当前线程 在串行队列中还有等待其他任务完成的意思。若是直接判断是否在主线程，就失去了等待队列按顺序调度任务的意思
        return try sync {
            return try DispatchQueue.main.syncIfNeed(action)
        }
    }
}