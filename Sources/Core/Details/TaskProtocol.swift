//
//  TaskProtocol.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
public protocol ProcessTask {
    func start(_ taskComplete: @escaping () -> Void)
    func isEqual(other: ProcessTask) -> Bool
}
public struct AsyncTask: ProcessTask {
    var hashValue: Int = {
        var hasher = Hasher()
        hasher.combine(Date().timeIntervalSince1970)
        return hasher.finalize()
    }()
    let task: (@escaping () -> Void) -> Void
    init(closure: @escaping (@escaping () -> Void) -> Void) {
        self.task = closure
    }
    public func start(_ taskComplete: @escaping () -> Void) {
        self.task(taskComplete)
    }

    public func isEqual(other: ProcessTask) -> Bool {
        guard let other = other as? AsyncTask else {
            return false
        }
        return self.hashValue == other.hashValue
    }
}
public struct SyncTask: ProcessTask {
    var hashValue: Int = {
        var hasher = Hasher()
        hasher.combine(Date().timeIntervalSince1970)
        return hasher.finalize()
    }()
    let task: () -> Void
    init(closure: @escaping () -> Void) {
        self.task = closure
    }
    public func start(_ taskComplete: @escaping () -> Void) {
        self.task()
        taskComplete()
    }

    public func isEqual(other: ProcessTask) -> Bool {
        guard let other = other as? SyncTask else {
            return false
        }
        return self.hashValue == other.hashValue
    }
}

enum TaskState {
    case working
    case free
}
// MARK: -
private var taskIsSuspendKey: UInt8 = 0
private var taskStateKey: UInt8 = 0
private var taskArrKey: UInt8 = 0
public protocol TaskProtocol: AssociatedObjectProtocol {
    typealias TaskItemType = ProcessTask

    func taskSuspend()
    func taskResume()

    func execute(task: TaskItemType, taskComplete: @escaping () -> Void)
}
public extension TaskProtocol {
    private var taskIsSuspend: Bool {
        get {return associatedObject(&taskIsSuspendKey, createIfNeed: true)}
        set {setAssociatedObject(&taskIsSuspendKey, newValue)}
    }
    private var taskState: TaskState {
        get {return associatedObject(&taskStateKey, createIfNeed: .free)}
        set {setAssociatedObject(&taskStateKey, newValue)}
    }
    public var taskArr: [TaskItemType] {
        get {return associatedObject(&taskArrKey, createIfNeed: [])}
        set {setAssociatedObject(&taskArrKey, newValue)}
    }

    func taskSuspend() {
        self.taskIsSuspend = true
    }
    func taskResume() {
        self.taskIsSuspend = false
        executeIfNeed()
    }

    func executeIfNeed() {
        objc_sync_enter(self); defer {objc_sync_exit(self)}
        guard self.taskIsSuspend == false else {
            return
        }
        guard self.taskState == .free else {
            return
        }
        guard let task = taskArr.first else {
            return
        }
        self.taskState = .working
        execute(task: task) {[weak self] in
            guard let `self` = self else {
                return
            }
            if self.taskArr.count > 0 {
                self.taskArr.removeFirst()
            }
            self.taskState = .free
            Async.main(after: 0.01) {
                self.executeIfNeed()
            }
        }
    }
    func execute(task: TaskItemType, taskComplete: @escaping () -> Void) {
        task.start(taskComplete)
    }
}
public extension TaskProtocol {
    func addTaskItem(_ taskItem: TaskItemType) {
        self.taskArr.append(taskItem)
        self.executeIfNeed()
    }
    func cleanAllTasks() {
        objc_sync_enter(self);defer {objc_sync_exit(self)}
        self.taskState = .free
        self.taskArr.removeAll()
    }
    func contains<T: TaskItemType>(_ taskType: T.Type) -> Bool {
        return self.taskArr.contains(where: {$0 is T})
    }
    func contains(_ task: TaskItemType) -> Bool {
        return self.taskArr.contains(where: task.isEqual)
    }
    func cancelTask(_ task: TaskItemType) -> Bool {
        objc_sync_enter(self);defer {objc_sync_exit(self)}
        if let index = self.taskArr.index(where: task.isEqual) {
            if index == 0 && self.taskState == .working {
                return false
            }
            self.taskArr.remove(at: index)
            return true
        } else {
            return false
        }
    }
}
// MARK: -
public extension TaskProtocol {
    @discardableResult
    func addTask(_ task: @escaping () -> Void) -> SyncTask {
        let result = SyncTask(closure: task)
        self.addTaskItem(result)
        return result
    }
    @discardableResult
    func addAsyncTask(_ task: @escaping (@escaping () -> Void) -> Void) -> AsyncTask {
        let result = AsyncTask(closure: task)
        self.addTaskItem(result)
        return result
    }
}
