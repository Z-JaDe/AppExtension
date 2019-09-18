//
//  HasNavConCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/5.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class HasNavConCoordinator: Coordinator, Flow,
    PushJumpPlugin,
    CoordinatorContainer {

    public var coordinators: [Coordinator] = []
    public weak var navCon: UINavigationController?
    public required init(_ navCon: UINavigationController?) {
        self.navCon = navCon
    }

    open func startNoViewCon() {

    }
}

public extension ViewControllerConvertible where Self: PushJumpPlugin {
    func jump(viewCon: UIViewController) {
        guard let navCon = navCon else { return }
        if navCon.viewControllers.isEmpty {
            navCon.viewControllers = [viewCon]
        } else {
            push(viewCon)
        }
    }
    func popToCurrentViewController() {
        if let viewCon = getViewCon(self.rootViewController) {
            self.navCon?.popToViewController(viewCon, animated: true)
        }
    }
    private func getViewCon(_ viewCon: UIViewController?) -> UIViewController? {
        guard let parentVC = viewCon?.parent else {
            return nil
        }
        if parentVC == viewCon?.navigationController {
            return viewCon
        }
        return getViewCon(parentVC)
    }
}
