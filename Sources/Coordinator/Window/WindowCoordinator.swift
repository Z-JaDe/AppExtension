//
//  WindowCoordinator.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/24.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

public typealias WindowRootItem = ViewControllerConvertible
public protocol AbstractWindowCoordinator: Coordinator, Flow,
    PresentJumpPlugin {

    var window: UIWindow! {get}
    func start(in window: UIWindow)
    var currentWindowItem: WindowRootItem? {get}
    /// ZJaDe: 传nil代表加载默认的item
    func load(_ item: WindowRootItem?)
}
public extension AbstractWindowCoordinator {
    func load(rootViewCon: UIViewController) {
        rootViewCon.view.layer.transform = CATransform3DMakeScale(0.9, 0.9, 0.9)
        UIView.transition(with: window, duration: 0.25, options: [.showHideTransitionViews,.transitionCrossDissolve], animations: {
            self.window.rootViewController = rootViewCon
            rootViewCon.view.layer.transform = CATransform3DIdentity
            if rootViewCon.presentedViewController != nil {
                /// ZJaDe: 有presentedViewController控制器时，苹果默认不会加载rootViewController.view，但是有时候presentedViewController只是半屏显示，rootViewController.view还是要加载的
                self.window.insertSubview(rootViewCon.view, at: 0)
            }
        }, completion: nil)
    }
    var rootViewController: UIViewController? {
        self.window.rootViewController
    }
}
