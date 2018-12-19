//
//  CanPushProtocol.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/// ZJaDe: 实现这个协议 说明该协调器可以push
public protocol CanPushProtocol {
    var navCon: UINavigationController? {get}
}
public extension CanPushProtocol {
    func push<T: Coordinator & RouteUrl>(_ coordinator: T, animated: Bool = true) {
        navCon?.navItemChildCoordinators[coordinator.rootViewController] = coordinator
        navCon?.pushViewController(coordinator.rootViewController, animated: animated)
    }
    func resetPush<T: Coordinator & RouteUrl>(_ coordinator: T, animated: Bool = true) {
        navCon?.navItemChildCoordinators[coordinator.rootViewController] = coordinator
        navCon?.setViewControllers([coordinator.rootViewController], animated: animated)
    }
    func reset<T: Coordinator & RouteUrl>(_ coordinators: [T], animated: Bool = true) {
        coordinators.forEach({navCon?.navItemChildCoordinators[$0.rootViewController] = $0})
        navCon?.setViewControllers(coordinators.map({$0.rootViewController}), animated: animated)
    }
    func popTo<T: Coordinator & RouteUrl>(_ coordinator: T, animated: Bool = true) -> Bool {
        if navCon?.viewControllers.contains(coordinator.rootViewController) == true {
            navCon?.popToViewController(coordinator.rootViewController, animated: animated)
            return true
        }
        return false
    }
    func popTo<T: Coordinator & AssociatedRootViewControllerProvider>(_ type: T.Type, animated: Bool = true) -> Bool {
        return navCon?.popTo(T.ViewControllerType.self, animated: animated) ?? false
    }
//    func containsNavItem<T: Coordinator & RouteUrl>(_ type: T.Type) -> Bool {
//        return navCon?.navItemChildCoordinators.values.contains(where: {$0 is T}) ?? false
//    }
//    func navItemChild<T: Coordinator & RouteUrl>(_ type: T.Type) -> T? {
//        return navCon?.navItemChildCoordinators.values.first(where: {$0 is T}) as? T
//    }
}

// MARK: -
private var childsKey: UInt8 = 0
extension UINavigationController {
    fileprivate var navItemChildCoordinators: [UIViewController: Any] {
        get {return associatedObject(&childsKey, createIfNeed: [: ])}
        set {
            setAssociatedObject(&childsKey, newValue)
        }
    }
    public func cleanUpChildCoordinators() {
        for viewController in navItemChildCoordinators.keys {
            if !self.viewControllers.contains(viewController) {
                navItemChildCoordinators.removeValue(forKey: viewController)
            }
        }
    }
}
