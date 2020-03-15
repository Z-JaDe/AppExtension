//
//  Updater.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/11/28.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

private var updaterKey: UInt8 = 0
extension UIScrollView {
    public var updater: Updater {
        get { associatedObject(&updaterKey, createIfNeed: Updater()) }
        set { setAssociatedObject(&updaterKey, newValue) }
    }
}

open class Updater {
    let taskQueue: TaskQueue = TaskQueue()
    internal var dataSet = false

    init() {
        self.taskQueue.taskResume()
    }
    public var isUpdating: Bool {
        taskQueue.isWorking
    }

    public struct DataSetter<C: Swift.Collection> {
        var updating: Updating
        let setData: (C) -> Void
        let completion: (Bool) -> Void

        public init(updating: Updating, setData: @escaping (C) -> Void, completion: @escaping (Bool) -> Void) {
            self.updating = updating
            self.setData = setData
            self.completion = completion
        }
    }
    open func update<C: Swift.Collection>(source: C, target: C, dataSetter: DataSetter<C>) {
        
    }
}
// MARK: -
extension Updater {
    public func performBatch(updating: Updating, updates: (() -> Void)?, completion: @escaping (Bool) -> Void) {
        safeExecute { (doneClosure) in
            updating.performBatch(updates: updates, completion: { (result) in
                completion(result)
                doneClosure()
            })
        }
    }
}
extension Updater {
    /// 每次执行 若是有旧的更新数据的任务，先删除再添加
    @inline(__always)
    private func dataSafeExecute(_ task: @escaping (@escaping () -> Void) -> Void) {
        taskQueue.cleanAllFreeTasks()
        taskQueue.addAsyncTask(task)
    }
    @inline(__always)
    private func safeExecute(_ task: @escaping (@escaping () -> Void) -> Void) {
        taskQueue.addAsyncTask(task)
    }
}
