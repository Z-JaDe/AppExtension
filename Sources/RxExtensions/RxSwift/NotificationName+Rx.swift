//
//  NotificationName+Rx.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

extension Notification.Name {
    public func notification() -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(self)
    }
}
extension Collection where Element == Notification.Name {
    public func notifications() -> [Observable<Notification>] {
        return self.map {$0.notification()}
    }
}
