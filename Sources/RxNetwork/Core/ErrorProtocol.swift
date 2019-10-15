//
//  RetryRequestProtocol.swift
//  Base
//
//  Created by ZJaDe on 2018/7/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

// MARK: -
/// ZJaDe: 实现该协议，把错误转换成NetworkError
public protocol MapErrorProtocol {
    func mapError() -> Error
}
extension Error {
    public func _mapError() -> Error {
        return (self as? MapErrorProtocol)?.mapError() ?? self
    }
}
