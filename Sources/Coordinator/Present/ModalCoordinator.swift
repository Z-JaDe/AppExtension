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

open class ModalCoordinator<ViewConType>: AbstractModalCoordinator,
    CanPresentProtocol,
    AssociatedRootViewControllerProvider
where ViewConType: CanCancelModalViewController & UIViewController {

    public private(set) lazy var viewCon: ViewConType = ViewConType()

    open func start(in flow: PresentFlow) {
        if let flow = flow as? InPresentFlow {
            flow.addChild(self)
        } else {
            viewCon._modalCoordinator = self
        }
        viewCon.didCancel = { [weak self, weak flow] () in
            guard let `self` = self else { return }
            self.didCancel()
            if let flow = flow as? InPresentFlow {
                flow.removeChild(self)
            } else {
                self.viewCon._modalCoordinator = nil
            }
        }
    }
    open func didCancel() {

    }
    public func cancel(completion: (() -> Void)? = nil) {
        self.viewCon.cancel(completion: completion)
    }
}
