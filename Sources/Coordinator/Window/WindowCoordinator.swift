//
//  WindowCoordinator.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/24.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public protocol WindowRootItem {
    func asWindowRootViewController() -> UIViewController?
}
public protocol AbstractWindowCoordinator: Coordinator, Presentable {

    var window: UIWindow! {get}
    func start(in window: UIWindow)
    var currentWindowItem: WindowRootItem? {get}
    /// ZJaDe: 传nil代表加载默认的item
    func load(_ item: WindowRootItem?)
}
public extension AbstractWindowCoordinator {
    func load(rootViewCon: UIViewController) {
        UIView.transition(with: window, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.window.rootViewController = rootViewCon
            if rootViewCon.presentedViewController != nil {
                /// ZJaDe: 有presentedViewController控制器时，苹果默认不会加载rootViewController.view，但是有时候presentedViewController只是半屏显示，rootViewController.view还是要加载的
                self.window.insertSubview(rootViewCon.view, at: 0)
            }
        }, completion: nil)
    }
    public func asPresentItem() -> UIViewController? {
        self.window.rootViewController
    }
}
