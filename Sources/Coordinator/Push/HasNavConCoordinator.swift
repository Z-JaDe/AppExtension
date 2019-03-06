//
//  HasNavConCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/5.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class HasNavConCoordinator: ViewConCoordinator,
    CoordinatorContainer,
    CanPushProtocol {
    public var coordinators: [Coordinator] = []

    public weak var navCon: UINavigationController?
    public required init(_ navCon: UINavigationController?) {
        self.navCon = navCon
    }

    open func startNoViewCon() {

    }
}

public extension RootViewControllerProvider where Self: CanPushProtocol {
    func load(viewCon: UIViewController) {
        guard let navCon = navCon else { return }
        if navCon.viewControllers.count <= 0 {
            navCon.viewControllers = [viewCon]
        } else {
            push(viewCon)
        }
    }
    func popToCurrentViewController() {
        if let viewCon = self.rootViewController {
            self.navCon?.popToViewController(viewCon, animated: true)
        }
    }
}
