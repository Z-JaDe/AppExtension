//
//  RootNavCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

// MARK: -
public protocol RootNavCoordinatorCompatible {
    func createNavigationController() -> UINavigationController
}
/// ZJaDe: 一个nav流程的 根协调器
open class RootNavCoordinator: Coordinator, CoordinatorContainer {

    public var coordinators: [Coordinator] = []
    /// ZJaDe: NavJumpable
    public lazy var navCon: UINavigationController = {
        let navCon = (self as? RootNavCoordinatorCompatible)?.createNavigationController()
            ?? UINavigationController()
        return navCon
    }()
    public init() {}
}
extension RootNavCoordinator: NavJumpable {
    public func asNavigationController() -> UINavigationController? {
        navCon
    }
}
extension RootNavCoordinator: Presentable {
    public func asPresentItem() -> UIViewController? {
        navCon
    }
}
// MARK: -
open class RootNavItemCoordinator<NavItemCoordinatorType>: RootNavCoordinator where NavItemCoordinatorType: NavItemCoordinatorCompatible {

    open func start() {
        let item = NavItemCoordinatorType.create(navCon)
        item.coordinator.start(in: item.viewCon)
        item.coordinator.jump(viewCon: item.viewCon)
    }
}
