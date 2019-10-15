//
//  NotificationCenter+Rx.swift
//  JDKit
//
//  Created by ZJaDe on 2017/11/23.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
extension Reactive where Base: NotificationCenter {
    // swiftlint:disable large_tuple
    public func notificationKeyboardWillChangeFrame() -> Observable<(CGRect, CGRect, TimeInterval)> {
        notification(UIResponder.keyboardWillChangeFrameNotification).map({ (notification) -> (CGRect, CGRect, TimeInterval)? in
            guard let userInfo = notification.userInfo else {
                return nil
            }
            guard let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else {
                return nil
            }
            guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                return nil
            }
            guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
                return nil
            }
            return (beginFrame, endFrame, animationDuration)
        }).filterNil()
    }
}
