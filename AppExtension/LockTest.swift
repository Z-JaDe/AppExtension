//
//  LockTest.swift
//  AppExtension
//
//  Created by Apple on 2019/4/26.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

func lockTest() {
    DispatchQueue.global().async {
        DispatchQueue.main.sync {
            print("11111")
        }
        print("22222")
    }
    
    let lock = ConditionLock()
    DispatchQueue.global().async {
        lock.lock(whenCondition: 4)
        print("线程1")
        sleep(2)
        print("线程1解锁")
        lock.unlock(withCondition: 5)
    }
    DispatchQueue.global().async {
        lock.lock(whenCondition: 0)
        print("线程2")
        sleep(3)
        print("线程2解锁")
        lock.unlock(withCondition: 2)
    }
    DispatchQueue.global().async {
        lock.lock(whenCondition: 2)
        print("线程3")
        sleep(3)
        print("线程3解锁")
        lock.unlock(withCondition: 3)
    }
    DispatchQueue.global().async {
        lock.lock(whenCondition: 3)
        print("线程4")
        sleep(2)
        print("线程4解锁")
        lock.unlock(withCondition: 4)
    }
}

class ConditionLock: NSLocking {
    let _con: NSCondition
    var _condition_value: Int
    init(condition value: Int = 0) {
        _con = NSCondition()
        _condition_value = value
    }
    func lock() {
        _con.lock()
    }
    func unlock() {
        _con.unlock()
    }
    
    func lock(whenCondition condition: Int) {
        _con.lock()
        while condition != _condition_value {
            print("检查等待\(condition)")
            _con.wait()
        }
    }
    func unlock(withCondition condition: Int) {
        _condition_value = condition
        _con.broadcast()
        _con.unlock()
    }
}
