//
//  ModalCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

/// ZJaDe: 可以被modal出来的 协调器
public typealias AbstractModalCoordinator = PresentedCoordinator & RootViewControllerProvider

public protocol CanCancelViewController {
    var didCancel: CallBackNoParams? {get set}
    func cancel()
    func cancel(completion: (() -> Void)?)
}
public extension CanCancelViewController {
    func cancel() {
        self.cancel(completion: nil)
    }
}

open class ModalCoordinator<ViewConType>: AbstractModalCoordinator,
    AssociatedRootViewControllerProvider
where ViewConType: CanCancelViewController & UIViewController {

    public private(set) lazy var viewCon: ViewConType = ViewConType()

    public var didCancel: CallBackNoParams?
    open func start(in flow: PresentFlow) {
        flow.addChild(self)
        viewCon.didCancel = { [weak self, weak flow] () in
            guard let `self` = self else { return }
            self.didCancel?()
            flow?.removeChild(self)
        }
    }
    public func cancel(completion: (() -> Void)? = nil) {
        self.viewCon.cancel(completion: completion)
    }
}
