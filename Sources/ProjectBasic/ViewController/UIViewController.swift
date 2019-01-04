//
//  UIViewController.swift
//  SNKit
//
//  Created by 郑军铎 on 2018/12/4.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
extension UIViewController {
    // MARK: - Notifition
    public func notification(_ name: Notification.Name) -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(name)
    }
    public func notifications(_ names: [Notification.Name]) -> [Observable<Notification>] {
        return names.map {notification($0)}
    }
}
