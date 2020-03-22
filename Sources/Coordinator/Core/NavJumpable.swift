//
//  NavJumpable.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/2.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

extension UIViewController: NavJumpable {
    public func asNavigationController() -> UINavigationController? {
        self.navigationController
    }
}
extension UIViewController: NavItemConvertible {
    public func asNavItem() -> UIViewController? {
        self
    }
}
// MARK: -
public protocol NavItemConvertible: class {
    func asNavItem() -> UIViewController?
}
public protocol AbstractNavItemConvertible: NavItemConvertible {
    associatedtype NavItemType: UIViewController
    var navItemViewCon: NavItemType? {get}
}
extension AbstractNavItemConvertible {
    public func asNavItem() -> UIViewController? {
        self.navItemViewCon
    }
}
public extension NavItemConvertible {
    func pop() {
        asNavItem()?.popVC()
    }
}
// MARK: - push跳转支持
public protocol NavJumpable {
    typealias NavItem = NavItemConvertible
    func asNavigationController() -> UINavigationController?
}
public extension NavJumpable {
    func push<T: NavItem>(item: T, animated: Bool = true) {
        guard let viewCon = item.asNavItem() else { return }
        guard let navCon = asNavigationController() else { return }
        navCon.pushViewController(viewCon, animated: animated)
    }
    func popAndPush<T: NavItem>(count: Int, item: T, animated: Bool = true) {
        guard let viewCon = item.asNavItem() else { return }
        guard let navCon = asNavigationController() else { return }
        navCon.popAndPush(count: count, pushVC: viewCon, animated: animated)
    }
    func popTo<T: NavItem>(item: T, animated: Bool = true) -> Bool {
        guard let viewCon = item.asNavItem() else { return false }
        guard let navCon = asNavigationController() else { return false }
        if navCon.viewControllers.contains(viewCon) == true {
            navCon.popToViewController(viewCon, animated: animated)
            return true
        }
        return false
    }
    func popTo<T: AbstractNavItemConvertible>(type: T.Type, animated: Bool = true) -> Bool {
        guard let navCon = asNavigationController() else { return false }
        return navCon.popTo(T.NavItemType.self, animated: animated)
    }
    func resetPush<T: NavItem>(item: T, animated: Bool = true) {
        guard let viewCon = item.asNavItem() else { return }
        guard let navCon = asNavigationController() else { return }
        navCon.setViewControllers([viewCon], animated: animated)
    }
    func reset<T: NavItem>(items: [T], animated: Bool = true) {
        guard let viewCons = items.map({$0.asNavItem()}) as? [UIViewController] else { return }
        guard let navCon = asNavigationController() else { return }
        navCon.setViewControllers(viewCons, animated: animated)
    }
}
public extension NavJumpable {
    func jump(viewCon: UIViewController) {
        guard let navCon = asNavigationController() else { return }
        if navCon.viewControllers.isEmpty {
            navCon.viewControllers = [viewCon]
        } else {
            push(item: viewCon)
        }
    }
}
// MARK: -
public extension NavJumpable where Self: NavItemConvertible {
    func popToCurrentViewController() {
        guard let viewCon = getViewCon(self.asNavItem()) else { return }
        guard let navCon = asNavigationController() else { return }
        navCon.popToViewController(viewCon, animated: true)
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
