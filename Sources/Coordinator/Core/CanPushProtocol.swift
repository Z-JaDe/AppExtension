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
public typealias CanPushItem = Coordinator & RouteUrl
public extension CanPushProtocol {
    func push<T: CanPushItem>(_ coordinator: T, animated: Bool = true) {
        navCon?.childrenCoordinators.append(coordinator)
        navCon?.pushViewController(coordinator.rootViewController, animated: animated)
    }
    func popAndPush<T: CanPushItem>(count: Int, _ coordinator: T, animated: Bool = true) {
        navCon?.childrenCoordinators.append(coordinator)
        navCon?.popAndPush(count: count, pushVC: coordinator.rootViewController, animated: animated)
    }
    func resetPush<T: CanPushItem>(_ coordinator: T, animated: Bool = true) {
        navCon?.childrenCoordinators.append(coordinator)
        navCon?.setViewControllers([coordinator.rootViewController], animated: animated)
    }
    func reset<T: CanPushItem>(_ coordinators: [T], animated: Bool = true) {
        navCon?.childrenCoordinators.append(contentsOf: coordinators)
        navCon?.setViewControllers(coordinators.map({$0.rootViewController}), animated: animated)
    }
    func popTo<T: CanPushItem>(_ coordinator: T, animated: Bool = true) -> Bool {
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
    fileprivate var childrenCoordinators: [CanPushItem] {
        get {return associatedObject(&childsKey, createIfNeed: [])}
        set {
            setAssociatedObject(&childsKey, newValue)
        }
    }
    public func cleanUpChildCoordinators() {
        childrenCoordinators = childrenCoordinators.filter({
            self.viewControllers.contains($0.rootViewController)
        })
    }
}
