//
//  RootCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

open class RootNavCoordinator<NavItemType>: RootCoordinator where NavItemType: AbstractNavItemCoordinator & NavItemCoordinatorProtocol {

    open func start() {
        let item = NavItemType.create(self.navCon)
        item.coor.start(in: item.viewCon)
        item.coor.jump(viewCon: item.viewCon)
    }
}
public protocol RootCoordinatorCompatible {
    func createNavigationController() -> UINavigationController
}
/// ZJaDe: 一个nav流程的 根协调器
open class RootCoordinator: Coordinator, Flow,
    PushJumpPlugin,
    PresentJumpPlugin,
    CoordinatorContainer {

    public var coordinators: [Coordinator] = []
    public var rootViewController: UIViewController? {
        self.navCon
    }
    /// ZJaDe: PushJumpPlugin
    public lazy var navCon: UINavigationController? = {
        let navCon = (self as? RootCoordinatorCompatible)?.createNavigationController()
            ?? UINavigationController()
        return navCon
    }()
    public init() {}
}
