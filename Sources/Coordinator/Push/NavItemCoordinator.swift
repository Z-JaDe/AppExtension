//
//  AbstractNavItemCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

/// ZJaDe: nav流程中的一个 item
public typealias AbstractNavItemCoordinator = HasNavConCoordinator & CanPresentProtocol

open class NavItemCoordinator<ViewConType>: AbstractNavItemCoordinator,
    AssociatedRootViewControllerProvider
    where ViewConType: UIViewController {

    open func start(in viewCon: ViewConType) {

    }

    public private(set) weak var viewCon: ViewConType?
    open func createViewCon() -> ViewConType {
        let viewCon = ViewConType()
        viewCon.coordinator = self
        return viewCon
    }
}
