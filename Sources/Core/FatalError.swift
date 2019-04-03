//
//  FatalError.swift
//  PaiBaoTang
//
//  Created by 茶古电子商务 on 2017/7/22.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

public func jdAbstractMethod(file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    jdFatalError("Abstract method", file: file, line: line)
}

public func jdFatalError(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> Swift.Never {
    fatalError(lastMessage(), file: file, line: line)
}

@available(*, unavailable, message: "使用assertionFailure")
public func jdFatalErrorInDebug(_ lastMessage: @autoclosure () -> String, file: StaticString = #file, method: String = #function, line: UInt = #line) {
    let message = lastMessage()
    #if DEBUG
        jdFatalError(message, file: file, line: line)
    #else
        logError(message, file: file, method: method, line: line)
    #endif
}

// MARK: -
infix operator !?
public func !?<T: ExpressibleByIntegerLiteral>
    (wrapped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}
public func !?<T: ExpressibleByArrayLiteral>
    (wrapped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? []
}
public func !?<T: ExpressibleByStringLiteral>
    (wrapped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? ""
}
public func !?<T> (wrapped: T?,
                   nilDefault: @autoclosure () -> (value: T, text: String)) -> T {
    assert(wrapped != nil, nilDefault().text)
    return wrapped ?? nilDefault().value
}
public func !? (wrapped: ()?,
                failureText: @autoclosure () -> String) {
    assert(wrapped != nil, failureText())
}
