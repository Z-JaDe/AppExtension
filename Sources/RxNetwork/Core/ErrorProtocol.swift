//
//  RetryRequestProtocol.swift
//  Base
//
//  Created by 郑军铎 on 2018/7/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
/// ZJaDe: Error实现该协议 截取信号重试
public protocol RetryRequestProtocol {
    func retryError() -> Observable<()>
}
extension ObservableType where Element == Error {
    internal func _retryError() -> Observable<()> {
        flatMapLatest({ (error) -> Observable<()> in
            if let error = error as? RetryRequestProtocol {
                return error.retryError()
            } else {
                throw error
            }
        })
    }
}
// MARK: -
/// ZJaDe: 实现该协议，把错误转换成NetworkError
public protocol MapErrorProtocol {
    func mapError() -> Error
}
extension Error {
    internal func _mapError() -> Error {
        (self as? MapErrorProtocol)?.mapError() ?? self
    }
}
