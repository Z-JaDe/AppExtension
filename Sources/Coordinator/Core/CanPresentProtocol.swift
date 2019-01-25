//
//  CanPresentProtocol.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/2.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

/// ZJaDe: 实现这个协议 说明该协调器可以present
public protocol CanPresentProtocol: RootViewControllerProvider {
    func present(_ coordinator: RootViewControllerProvider, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}
public extension CanPresentProtocol {
    func present(_ coordinator: RootViewControllerProvider, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let rootViewCon = coordinator.rootViewController
            if rootViewCon.isBeingDismissed || rootViewCon.isBeingPresented == false {
                self.rootViewController.present(rootViewCon, animated: animated, completion: completion)
            } else {
                assertionFailure("控制器已经显示")
            }
        }
    }
    /// ZJaDe: 不一定会调用这个方法，有可能控制器自己调用了dismiss，比如实现了CanCancelModalViewController协议时
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let rootViewCon = self.rootViewController
            if rootViewCon.isBeingPresented || rootViewCon.isBeingDismissed == false {
                rootViewCon.dismiss(animated: animated, completion: completion)
            } else {
                assertionFailure("控制器已经消失")
            }
        }
    }
}

extension UIViewController: CanPresentProtocol {}
