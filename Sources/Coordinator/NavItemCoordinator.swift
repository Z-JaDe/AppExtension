//
//  AbstractNavItemCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

/// ZJaDe: nav流程中的一个 item
public typealias AbstractNavItemCoordinator = HasNavConCoordinator & RouteUrl & CanPresentProtocol

open class NavItemCoordinator<ViewConType>: AbstractNavItemCoordinator,
    AssociatedRootViewControllerProvider
    where ViewConType: UIViewController {

    public private(set) lazy var viewCon: ViewConType = ViewConType()
}
