//
//  HasNavConCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/5.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class HasNavConCoordinator: Coordinator, CoordinatorContainer, CanPushProtocol {
    public var coordinators: [Coordinator] = []

    public weak var navCon: UINavigationController?
    public required init(_ navCon: UINavigationController?) {
        self.navCon = navCon
    }

    open func start() {

    }
}
public extension RouteUrl where Self: HasNavConCoordinator {
    func load() {
        guard let navCon = navCon else { return }
        if navCon.viewControllers.count <= 0 {
            navCon.viewControllers = [rootViewController]
        } else {
            push(self)
        }
    }
    func popToCurrentViewController() {
        self.navCon?.popToViewController(self.rootViewController, animated: true)
    }
}
