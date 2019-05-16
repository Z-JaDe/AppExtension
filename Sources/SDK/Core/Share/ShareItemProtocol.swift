//
//  ShareProtocol.swift
//  zjmax
//
//  Created by 郑军铎 on 2018/8/21.
//  Copyright © 2018年 数牛. All rights reserved.
//

import Foundation

private var shareKey: UInt8 = 0
public protocol ShareItemProtocol: AssociatedObjectProtocol {
    typealias CallbackType = (Bool) -> Void
    func shareCallBack(isSuccessful: Bool)
}
public extension ShareItemProtocol {
    func setShareCallback(_ closure: CallbackType?) {
        setAssociatedObject(&shareKey, closure)
    }
    func shareCallBack(isSuccessful: Bool) {
        if let callback: CallbackType = associatedObject(&shareKey) {
            callback(isSuccessful)
            setShareCallback(nil)
        }
    }
}
