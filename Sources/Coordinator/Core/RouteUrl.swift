//
//  RouteUrl.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
/// ZJaDe: 代表有控制器的协调器
public protocol RootViewControllerProvider: class {
    var rootViewController: UIViewController? { get }
}
/// ZJaDe: 代表有控制器的协调器，实现时只要有viewCon属性即可
public protocol AssociatedRootViewControllerProvider: RootViewControllerProvider {
    associatedtype ViewControllerType: UIViewController
    var viewCon: ViewControllerType {get}
}
extension AssociatedRootViewControllerProvider {
    public var rootViewController: UIViewController? {
        return self.viewCon
    }
}
/// ZJaDe: 代表一个页面
public protocol RouteUrl: RootViewControllerProvider {}
public extension RouteUrl {
    func pop() {
        self.rootViewController?.popVC()
    }
}

extension UIViewController: RouteUrl {
    public var rootViewController: UIViewController? {
        return self
    }
}
