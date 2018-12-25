//
//  CanCancelViewController.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2018/12/25.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol CanCancelModalViewController {
    var didCancel: CallBackNoParams? {get set}
    func cancel()
    func cancel(completion: (() -> Void)?)
}
public extension CanCancelModalViewController {
    func cancel() {
        self.cancel(completion: nil)
    }
}
private var coordinatorKey: UInt8 = 0
public extension CanCancelModalViewController where Self: UIViewController {
    internal var _modalCoordinator: PresentedCoordinator? {
        get {return associatedObject(&coordinatorKey)}
        set {setAssociatedObject(&coordinatorKey, newValue)}
    }
    func getModalCoordinator() -> PresentedCoordinator? {
        return _modalCoordinator
    }
}
