//
//  PayItemProtocol.swift
//  zjmax
//
//  Created by 郑军铎 on 2018/8/21.
//  Copyright © 2018年 数牛. All rights reserved.
//

import Foundation

private var payKey: UInt8 = 0
public protocol PayItemProtocol: AssociatedObjectProtocol {
    typealias CallbackType = (Bool) -> Void
    func payCallBack(isSuccessful: Bool)
}
extension PayItemProtocol {
    func setPayCallback(_ closure: CallbackType?) {
        setAssociatedObject(&payKey, closure)
    }
    public func payCallBack(isSuccessful: Bool) {
        if let callback: CallbackType = associatedObject(&payKey) {
            callback(isSuccessful)
            setPayCallback(nil)
        }
    }
}
