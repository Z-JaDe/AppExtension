//
//  CanCancelModalViewController.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2018/12/25.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol CanCancelModalViewController {
    var didCancel: CallBackerNoParams {get}
    func cancel()
    func cancel(completion: (() -> Void)?)
}
public extension CanCancelModalViewController {
    func cancel() {
        self.cancel(completion: nil)
    }
}
