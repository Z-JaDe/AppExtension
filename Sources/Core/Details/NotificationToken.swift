//
//  NotificationToken.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 16/12/9.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

public final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}
extension NotificationCenter {
    public func observe(
        name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
        ) -> NotificationToken {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}
