//
//  Transaction.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/10.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public struct Transaction {
    private let target: AnyObject
    private let selector: Selector

    public init(target: AnyObject, selector: Selector) {
        self.target = target
        self.selector = selector
    }
    func perform() {
        _ = target.perform(selector)
    }
}
extension Transaction: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(target))
        hasher.combine(selector)
    }
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
private var transactionSet = Set<Transaction>()
extension Transaction {
    public func commit() {
        transactionSetup()
        transactionSet.insert(self)
    }
    private func transactionSetup() {
        _ = observer
    }
}
let observer: CFRunLoopObserver! = {
    let activity: CFRunLoopActivity = [.beforeWaiting, .exit]
    let observer = CFRunLoopObserverCreate(
        // swiftlint:disable force_cast
        (CFAllocatorGetDefault() as! CFAllocator),
        activity.rawValue,
        true,
        0xFFFFFF, // after CATransaction(2000000)
        runLoopObserverCallBack,
        nil)
    // ZJaDe:
    let runloop: CFRunLoop = CFRunLoopGetMain()
    CFRunLoopAddObserver(runloop, observer, .commonModes)
    return observer
}()
private let runLoopObserverCallBack: CFRunLoopObserverCallBack = { (observer, activity, info) -> Void in
    for transaction in transactionSet {
        transaction.perform()
    }
    transactionSet.removeAll()
}
