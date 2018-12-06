//
//  BufferPool.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/17.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
public protocol BufferPoolItemProtocol {

}

public class BufferPool {
    public init() {}
    private let lock = NSLock()
    private var dataArray: [String: [NSObject]] = [: ]

    public func push<T: NSObject&BufferPoolItemProtocol>(_ obj: T, key: String?) {
        lock.lock(); defer {lock.unlock()}
        let key = key ?? obj.classFullName
        var array: [T] = dataArray[key]?.compactMap({$0 as? T}) ?? []
        array.append(obj)
//        logDebug("\(obj)->: \(key) 加入缓存池")
        dataArray[key] = array
    }
    public func pop<T: NSObject&BufferPoolItemProtocol>(_ key: String) -> T? {
        lock.lock(); defer {lock.unlock()}
        let result: T?
        var array: [NSObject] = dataArray[key] ?? []
        if let item = array.last as? T {
            result = item
            array.removeLast()
//            logDebug("\(item)->: \(key) 取出缓存池")
        } else {
            result = nil
        }
        dataArray[key] = array
        return result
    }

    public func push<T: NSObject&BufferPoolItemProtocol>(_ obj: T) {
        push(obj, key: obj.classFullName)
    }
    public func pop<T: NSObject&BufferPoolItemProtocol>(_ type: T) -> T? {
        return pop(T.classFullName)
    }
}
