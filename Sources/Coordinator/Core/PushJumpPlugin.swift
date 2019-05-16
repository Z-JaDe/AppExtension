//
//  PushJumpPlugin.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/// ZJaDe: push跳转支持
public protocol PushJumpPlugin {
    var navCon: UINavigationController? {get}
}
extension UIViewController: PushJumpPlugin {
    public var navCon: UINavigationController? {
        return self.navigationController
    }
}
public extension PushJumpPlugin {
    func push<T: ViewControllerConvertible>(_ item: T, animated: Bool = true) {
        guard let viewCon = item.rootViewController else { return }
        navCon?.pushViewController(viewCon, animated: animated)
    }
    func popAndPush<T: ViewControllerConvertible>(count: Int, _ item: T, animated: Bool = true) {
        guard let viewCon = item.rootViewController else { return }
        navCon?.popAndPush(count: count, pushVC: viewCon, animated: animated)
    }
    func resetPush<T: ViewControllerConvertible>(_ item: T, animated: Bool = true) {
        guard let viewCon = item.rootViewController else { return }
        navCon?.setViewControllers([viewCon], animated: animated)
    }
    func reset<T: ViewControllerConvertible>(_ items: [T], animated: Bool = true) {
        guard let viewCons = items.map({$0.rootViewController}) as? [UIViewController] else { return }
        navCon?.setViewControllers(viewCons, animated: animated)
    }
    func popTo<T: ViewControllerConvertible>(_ item: T, animated: Bool = true) -> Bool {
        guard let viewCon = item.rootViewController else { return false }
        if navCon?.viewControllers.contains(viewCon) == true {
            navCon?.popToViewController(viewCon, animated: animated)
            return true
        }
        return false
    }
    func popTo<T: AssociatedViewControllerConvertible>(_ type: T.Type, animated: Bool = true) -> Bool {
        return navCon?.popTo(T.ViewControllerType.self, animated: animated) ?? false
    }
}
