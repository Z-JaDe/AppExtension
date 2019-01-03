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
