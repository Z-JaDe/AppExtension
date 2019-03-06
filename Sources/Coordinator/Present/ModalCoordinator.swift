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

    public private(set) weak var viewCon: ViewConType?
    open func createViewCon() -> ViewConType {
        let viewCon = ViewConType()
        viewCon.coordinator = self
        return viewCon
    }

    open func start(in viewCon: ViewConType) {
    }
    open func didCancel() {

    }
    public func cancel(completion: (() -> Void)? = nil) {
        self.viewCon?.cancel(completion: completion)
    }
}
