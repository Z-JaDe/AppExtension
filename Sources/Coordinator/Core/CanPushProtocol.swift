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
extension UIViewController: CanPushProtocol {
    public var navCon: UINavigationController? {
        return self.navigationController
    }
}
public extension CanPushProtocol {
    typealias CanPushItem = RouteUrl
    func push<T: CanPushItem>(_ item: T, animated: Bool = true) {
        guard let viewCon = item.rootViewController else { return }
        navCon?.pushViewController(viewCon, animated: animated)
    }
    func popAndPush<T: CanPushItem>(count: Int, _ item: T, animated: Bool = true) {
        guard let viewCon = item.rootViewController else { return }
        navCon?.popAndPush(count: count, pushVC: viewCon, animated: animated)
    }
    func resetPush<T: CanPushItem>(_ item: T, animated: Bool = true) {
        guard let viewCon = item.rootViewController else { return }
        navCon?.setViewControllers([viewCon], animated: animated)
    }
    func reset<T: CanPushItem>(_ items: [T], animated: Bool = true) {
        guard let viewCons = items.map({$0.rootViewController}) as? [UIViewController] else { return }
        navCon?.setViewControllers(viewCons, animated: animated)
    }
    func popTo<T: CanPushItem>(_ item: T, animated: Bool = true) -> Bool {
        guard let viewCon = item.rootViewController else { return false }
        if navCon?.viewControllers.contains(viewCon) == true {
            navCon?.popToViewController(viewCon, animated: animated)
            return true
        }
        return false
    }
    func popTo<T: AssociatedRootViewControllerProvider>(_ type: T.Type, animated: Bool = true) -> Bool {
        return navCon?.popTo(T.ViewControllerType.self, animated: animated) ?? false
    }
//    func containsNavItem<T: Coordinator & RouteUrl>(_ type: T.Type) -> Bool {
//        return navCon?.navItemChildCoordinators.values.contains(where: {$0 is T}) ?? false
//    }
//    func navItemChild<T: Coordinator & RouteUrl>(_ type: T.Type) -> T? {
//        return navCon?.navItemChildCoordinators.values.first(where: {$0 is T}) as? T
//    }
}
