//
//  RootCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

open class RootNavCoordinator<NavItemType>: RootCoordinator where NavItemType: AbstractNavItemCoordinator {
    public lazy var rootItem = NavItemType(self.navCon)

    open func start() {
        rootItem.start()
        rootItem.load()
    }
}
public protocol RootCoordinatorCompatible {
    func createNavigationController() -> UINavigationController
}
/// ZJaDe: 一个nav流程的 根协调器
open class RootCoordinator: ViewConCoordinator,
    CanPushProtocol,
    CanPresentProtocol,
    CoordinatorContainer {
    /// ZJaDe: CoordinatorContainer
    public var coordinators: [Coordinator] = []
    /// ZJaDe: RootViewControllerProvider
    public var rootViewController: UIViewController {
        return self.navCon!
    }
    /// ZJaDe: CanPushProtocol
    public lazy var navCon: UINavigationController? = {
        let navCon = (self as? RootCoordinatorCompatible)?.createNavigationController()
            ?? UINavigationController()
        return navCon
    }()
    public init() {}
}
