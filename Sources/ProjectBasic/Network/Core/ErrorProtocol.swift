//
//  RetryRequestProtocol.swift
//  Base
//
//  Created by 郑军铎 on 2018/7/11.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol RetryRequestProtocol {
    func retryError() -> Observable<()>
}
extension ObservableType where E == Error {
    internal func _retryError() -> Observable<()> {
        return flatMapLatest({ (error) -> Observable<()> in
            if let error = error as? RetryRequestProtocol {
                return error.retryError()
            } else {
                throw error
            }
        })
    }
}
// MARK: -
public protocol MapErrorProtocol {
    func mapError() -> Error
}
extension Error {
    internal func _mapError() -> Error {
        return (self as? MapErrorProtocol)?.mapError() ?? self
    }
}
