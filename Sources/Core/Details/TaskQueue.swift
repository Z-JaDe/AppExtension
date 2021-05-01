//
//  TaskProtocol.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/6.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

private var taskSentinel = Sentinel()
public protocol ProcessTask {
    func start(taskComplete: @escaping () -> Void)
    func isEqual(other: ProcessTask) -> Bool
}
public struct AsyncTask: ProcessTask {
    let tag: Int32 = taskSentinel.increase()
    let task: (@escaping () -> Void) -> Void
    init(closure: @escaping (@escaping () -> Void) -> Void) {
        self.task = closure
    }
    public func start(taskComplete: @escaping () -> Void) {
        self.task(taskComplete)
    }

    public func isEqual(other: ProcessTask) -> Bool {
        guard let other = other as? AsyncTask else {
            return false
        }
        return self.tag == other.tag
    }
}
public struct SyncTask: ProcessTask {
    let tag: Int32 = taskSentinel.increase()
    let task: () -> Void
    init(closure: @escaping () -> Void) {
        self.task = closure
    }
    public func start(taskComplete: @escaping () -> Void) {
        self.task()
        taskComplete()
    }

    public func isEqual(other: ProcessTask) -> Bool {
        guard let other = other as? SyncTask else {
            return false
        }
        return self.tag == other.tag
    }
}

enum TaskState {
    case working
    case free
}
// MARK: -
public protocol TaskQueueProtocol {
    var taskQueue: TaskQueue {get}
}
/// 可以用在控制流程，UI执行顺序等异步任务
public class TaskQueue {
    public typealias TaskItem = ProcessTask
    /// 串行队列，只维护类内部taskArr、taskState的数据安全，队列不执行Task任务
    let queue = DispatchQueue(label: "com.zjade.task")
    private var taskIsSuspend: Bool
    private var taskState: TaskState = .free
    private var taskArr: [TaskItem] = []
    public init() {
        self.taskIsSuspend = true
    }
    public var isWorking: Bool {
        taskState == .working
    }
}
// MARK: 任务暂停、恢复
public extension TaskQueue {
    func taskSuspend() {
        performInMain {
            self.taskIsSuspend = true
        }
    }
    func taskResume() {
        performInMain {
            self.taskIsSuspend = false
        }
    }
}
// MARK: 是否包含任务
public extension TaskQueue {
    func contains<T: TaskItem>(_ taskType: T.Type) -> Bool {
        queue.syncIfNeed {
            return self.taskArr.contains(where: {$0 is T})
        }
    }
    func contains(_ task: TaskItem) -> Bool {
        queue.syncIfNeed {
            return self.taskArr.contains(where: task.isEqual)
        }
    }
}
// MARK: 添加、移除任务
public extension TaskQueue {
    /// 包括正在执行中的任务
    func cleanAllTasks() {
        queue.async {
            self.taskState = .free
            self.taskArr.removeAll()
        }
    }
    /// 不包括正在执行中的任务
    func cleanAllFreeTasks() {
        queue.async {
            switch self.taskState {
            case .free:
                self.taskArr.removeAll()
            case .working:
                if let first = self.taskArr.first {
                    self.taskArr = [first]
                }
            }
        }
    }
    func cancelTask(_ task: TaskItem) -> Bool {
        queue.syncIfNeed {
            if let index = self.taskArr.firstIndex(where: task.isEqual) {
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
}
public extension TaskQueue {
    func addTaskItem(_ taskItem: TaskItem) {
        queue.async {
            self.taskArr.append(taskItem)
            self.executeIfNeed()
        }
    }
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
// MARK: 执行任务
private extension TaskQueue {
    /// 由于queue是串行队列，同一时刻只会执行一次executeIfNeed
    func executeIfNeed() {
        guard self.taskIsSuspend == false else { return }
        guard self.taskState == .free else { return }
        guard let task = self.taskArr.first else { return }
        self.taskState = .working
        DispatchQueue.main.async {
            task.start(taskComplete: {[weak self] in
                guard let self = self else { return }
                self.queue.async {
                    if self.taskArr.isEmpty {
                        self.taskState = .free
                        assertionFailure("逻辑上来讲 永远不会走到这里, 需要检查代码问题")
                    } else if self.removeTask(task) { // 删除成功 说明该任务没有被强制关闭，继续执行下一个任务
                        self.taskState = .free
                        self.executeIfNeed()
                    }
                }
            })
        }
    }
    func removeTask(_ task: TaskItem) -> Bool {
        if let index = self.taskArr.firstIndex(where: task.isEqual) {
            self.taskArr.remove(at: index)
            return true
        } else {
            return false
        }
    }
}
