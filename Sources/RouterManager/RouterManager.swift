//
//  RouterManager.swift
//  ZiWoYou
//
//  Created by Z_JaDe on 2016/10/19.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

#if !AppExtensionPods
@_exported import Core
#endif
/// ZJaDe: 路线类型
public enum RouteType {
    case push
    case present
    case showPresent
    case popAndPush(popCount: Int)
}
public protocol RouterManagerCompatible {
    func createNavCon(_ rootVC: UIViewController) -> UINavigationController
}
import UIKit
/// ZJaDe: 路由器管理
public class RouterManager {
    public private(set) var routeType: RouteType = .push
    private let currentNavC: UINavigationController
    public init(_ currentNavC: UINavigationController) {
        self.currentNavC = currentNavC
    }
    // MARK: -
    @discardableResult
    public func popTo<T: UIViewController>(_ VCType: T.Type, animated: Bool = true) -> Bool {
        return currentNavC.popTo(VCType, animated: animated)
    }
    public func pop(count: Int, animated: Bool = true) {
        self.currentNavC.pop(count: count, animated: animated)
    }
    public func popToRoot(animated: Bool = true) {
        self.currentNavC.popToRootViewController(animated: animated)
    }
    // MARK: - popToVCAndPush
    public func popToRootVCAndPush(_ routeUrl: RouteUrlType) {
        let count = currentNavC.viewControllers.count - 1
        self.popAndPush(routeUrl, popCount: count)
    }
    public func popToVCAndPush<T: UIViewController>(to VCType: T.Type, _ routeUrl: RouteUrlType) -> Bool {
        if let index = currentNavC.viewControllers.lazy.reversed().enumerated().first(where: {$0.element is T})?.offset {
            let count = index + 1
            self.popAndPush(routeUrl, popCount: count)
            return true
        } else {
            return false
        }
    }

    // MARK: - popAndPush
    public func popAndPush(_ routeUrl: RouteUrlType, popCount: Int = 1, animated: Bool = true) {
        self.routeType = .popAndPush(popCount: popCount)
        DispatchQueue.main.async {
            guard let viewCon = self.parse(routeUrl) else {
                return
            }
            self.currentNavC.popAndPush(count: popCount, pushVC: viewCon, animated: animated)
        }
    }
    // MARK: - reset
    public func resetPush(_ routeUrl: RouteUrlType, animated: Bool) {
        self.reset([routeUrl], animated: animated)
    }
    public func reset(_ routeUrls: [RouteUrlType], animated: Bool) {
        DispatchQueue.main.async {
            guard let viewCons = self.parse(routeUrls) else {
                return
            }
            self.currentNavC.setViewControllers(viewCons, animated: animated)
        }
    }
    // MARK: - push
    public func push(_ routeUrl: RouteUrlType, animated: Bool = true) {
        self.routeType = .push
        DispatchQueue.main.async {
            guard let viewCon = self.parse(routeUrl) else {
                return
            }
            self.currentNavC.pushViewController(viewCon, animated: animated)
        }
    }
    // MARK: - present
    public func present(_ routeUrl: RouteUrlType, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.routeType = .present
        DispatchQueue.main.async {
            guard let tempViewCon = self.parse(routeUrl) else {
                return
            }
            let viewCon: UINavigationController = (tempViewCon as? UINavigationController)
                ?? (self as? RouterManagerCompatible)?.createNavCon(tempViewCon)
                ?? UINavigationController(rootViewController: tempViewCon)

            if viewCon.presentingViewController == nil {
                self.currentNavC.present(viewCon, animated: animated, completion: completion)
            } else {
                logError("当前控制器已经present")
            }
        }
    }
    // MARK: - showPresent
    public func showPresent(_ routeUrl: RouteUrlType, animated: Bool = true, completion: (() -> Void)? = nil) {
        self.routeType = .showPresent
       DispatchQueue.main.async {
            guard let viewCon = self.parse(routeUrl) else {
                return
            }
            if viewCon.presentingViewController == nil {
                self.currentNavC.present(viewCon, animated: animated, completion: completion)
            } else {
                logError("当前控制器已经present")
            }
        }
    }
    // MARK: -
    /// ZJaDe: 解析routeUrl
    public func parse(_ routeUrl: RouteUrlType) -> UIViewController? {
        endEditing()
        guard let viewController = routeUrl.createViewCon(self) else {
            logError("跳转失败\(routeUrl)")
            return nil
        }
        return viewController
    }
    public func parse(_ routeUrls: [RouteUrlType]) -> [UIViewController]? {
        endEditing()
        guard let viewControllers = routeUrls.map({$0.createViewCon(self)}) as? [UIViewController] else {
            logError("跳转失败\(routeUrls)")
            return nil
        }
        return viewControllers
    }

    private func endEditing() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
