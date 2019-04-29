//
//  GCDTest.swift
//  AppExtension
//
//  Created by Apple on 2019/4/29.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Core
func gcdTest() {
//    let queue = DispatchQueue(label: "qqq", target: DispatchQueue.main)
//    let spec = DispatchSpecificKey<String>()
//    queue.setSpecific(key: spec, value: queue.label)
//    DispatchQueue.global().async {
//        print("1\(Thread.current)")
//        queue.async {
//            print("2\(Thread.current)")
//            let label = DispatchQueue.getSpecific(key: spec)
//            print(label ?? "")
//        }
//        print("3\(Thread.current)")
//    }
    // MARK: - taskQueue
//    let taskQueue = TaskQueue()
//    taskQueue.addAsyncTask { (done) in
//        print("1\(Thread.current)")
//        done()
//        print("2\(Thread.current)")
//    }
//    taskQueue.taskResume()
//    var task:ProcessTask?
//    task = taskQueue.addTask {
//        print("是否包含\(taskQueue.contains(task!))")
//    }
    // MARK: - callbacker
//    let callbacker = CallBackerNoParams()
//    callbacker.register(on: UIApplication.shared) { (_) in
//        print("default")
//    }
//    callbacker.register(on: UIApplication.shared, key: "aaa") { (_) in
//        print("aaa")
//    }
//    callbacker.call()
}
