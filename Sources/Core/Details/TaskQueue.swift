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
        hasher.combine(UUID().uuidString)
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
        hasher.combine(UUID().uuidString)
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
public protocol TaskQueueProtocol {
    var taskQueue: TaskQueue {get}
}
/// 可以用在控制流程，UI执行顺序等异步任务
public class TaskQueue {
    public typealias TaskItem = ProcessTask
    let queue = DispatchQueue(label: "com.zjade.task")
    private var taskIsSuspend: Bool
    private var taskState: TaskState = .free
    private var taskArr: [TaskItem] = []
    public init() {
        self.taskIsSuspend = true
        self.queue.suspend()
    }
    deinit {
        if self.taskIsSuspend {
            self.queue.resume()
        }
    }
}
public extension TaskQueue {
    func taskSuspend() {
        performInMainAsync {
            if self.taskIsSuspend == false {
                self.taskIsSuspend = true
                self.queue.suspend()
            }
        }
    }
    func taskResume() {
        performInMainAsync {
            if self.taskIsSuspend {
                self.taskIsSuspend = false
                self.queue.resume()
            }
        }
    }

    private func executeIfNeed() {
        queue.async {
            guard self.taskIsSuspend == false else { return }
            guard self.taskState == .free else { return }
            guard let task = self.taskArr.first else { return }
            self.taskState = .working
            self.execute(task: task) {[weak self] in
                guard let `self` = self else { return }
                self.queue.async {
                    if self.taskArr.count > 0 {
                        self.taskArr.removeFirst()
                    }
                    self.taskState = .free
                    self.executeIfNeed()
                }
            }
        }
    }
    private func execute(task: TaskItem, taskComplete: @escaping () -> Void) {
        DispatchQueue.main.async {
            task.start(taskComplete)
        }
    }
}
public extension TaskQueue {
    func cleanAllTasks() {
        queue.async {
            self.taskState = .free
            self.taskArr.removeAll()
        }
    }
    func contains<T: TaskItem>(_ taskType: T.Type) -> Bool {
        return queue.syncIfNeed {
            return self.taskArr.contains(where: {$0 is T})
        }
    }
    func contains(_ task: TaskItem) -> Bool {
        return queue.syncIfNeed {
            return self.taskArr.contains(where: task.isEqual)
        }
    }
    func cancelTask(_ task: TaskItem) -> Bool {
        return queue.syncIfNeed {
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
// MARK: -
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
