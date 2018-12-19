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
    func showModal(_ coordinator: RootViewControllerProvider, animated: Bool, completion: (() -> Void)?)
    func cancelModal(animated: Bool, completion: (() -> Void)?)
}
public extension CanPresentProtocol {
    func showModal(_ coordinator: RootViewControllerProvider, animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let rootViewCon = coordinator.rootViewController
            if rootViewCon.isBeingDismissed || rootViewCon.isBeingPresented == false {
                self.rootViewController.present(rootViewCon, animated: animated, completion: completion)
            } else {
                assertionFailure("控制器已经显示")
            }
        }
    }
    func cancelModal(animated: Bool = true, completion: (() -> Void)? = nil) {
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
