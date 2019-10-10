//
//  RetryRequestProtocol.swift
//  Base
//
//  Created by 郑军铎 on 2018/7/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

// MARK: -
/// ZJaDe: 实现该协议，把错误转换成NetworkError
public protocol MapErrorProtocol {
    func mapError() -> NetworkError
}
extension Error {
    internal func _mapError() -> Error {
        (self as? MapErrorProtocol)?.mapError() ?? self
    }
}
