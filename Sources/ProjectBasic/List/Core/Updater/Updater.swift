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
        get { associatedObject(&updaterKey, createIfNeed: DifferenceKitUpdater()) }
        set { setAssociatedObject(&updaterKey, newValue) }
    }
}

open class Updater {
    private let taskQueue: TaskQueue = TaskQueue()
    internal var dataSet = false
    public var tempUpdateMode: UpdateMode?
    init() {
        self.taskQueue.taskResume()
    }
    public var isUpdating: Bool {
        taskQueue.isWorking
    }

    public struct DataSetter<Element> {
        var updating: Updating
        let setData: ([Element]) -> Void
        let completion: (Bool) -> Void

        public init(updating: Updating, setData: @escaping ([Element]) -> Void, completion: @escaping (Bool) -> Void) {
            self.updating = updating
            self.setData = setData
            self.completion = completion
        }
    }
    open func update<Element: Hashable>(source: [Element], target: [Element], dataSetter: DataSetter<Element>) {
        dataSafeExecute { (doneClosure) in
            dataSetter._reload(data: target, done: doneClosure)
        }
    }
}
extension Updater.DataSetter {
    @inline(__always)
    public func _reload(data: [Element]?, done: @escaping () -> Void) {
        guard let data = data else {
            self.completion(true)
            done()
            return
        }
        setData(data)
        updating.reload {
            self.completion(true)
            done()
        }
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
    internal func dataSafeExecute(_ task: @escaping (@escaping () -> Void) -> Void) {
        taskQueue.cleanAllFreeTasks()
        taskQueue.addAsyncTask(task)
    }
    @inline(__always)
    internal func safeExecute(_ task: @escaping (@escaping () -> Void) -> Void) {
        taskQueue.addAsyncTask(task)
    }
}
