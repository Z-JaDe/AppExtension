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
public protocol MapErrorProtocol {
    func mapError() -> Error
}
