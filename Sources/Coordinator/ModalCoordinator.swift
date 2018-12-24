//
//  ModalCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit

/// ZJaDe: 可以被modal出来的 协调器
public typealias AbstractModalCoordinator = PresentedCoordinator & RootViewControllerProvider

open class ModalCoordinator<ViewConType>: AbstractModalCoordinator,
    CanPresentProtocol,
    AssociatedRootViewControllerProvider
where ViewConType: CanCancelViewController & UIViewController {

    public private(set) lazy var viewCon: ViewConType = ViewConType()

    open func start(in flow: PresentFlow) {
        viewCon._modalCoordinator = self
        viewCon.didCancel = { [weak self, weak flow] () in
            guard let `self` = self else { return }
            self.didCancel()
            self.viewCon._modalCoordinator = nil
        }
    }
    open func didCancel() {

    }
    public func cancel(completion: (() -> Void)? = nil) {
        self.viewCon.cancel(completion: completion)
    }
}

// MARK: -
public typealias WindowRootItem = Coordinator & RootViewControllerProvider
public protocol AbstractWindowCoordinator: ViewConCoordinator, CanPresentProtocol {
    var window: UIWindow! {get}
    func start(in window: UIWindow)
    var currentWindowItem: WindowRootItem? {get}
}
public extension AbstractWindowCoordinator {
    func load(rootViewCon: UIViewController) {
        Animater().animations {
            self.window.rootViewController = rootViewCon
            if rootViewCon.presentedViewController != nil {
                /// ZJaDe: 有presentedViewController控制器时，苹果默认不会加载rootViewController.view，但是有时候presentedViewController只是半屏显示，rootViewController.view还是要加载的
                self.window.insertSubview(rootViewCon.view, at: 0)
            }
        }.options([.transitionCrossDissolve]).transition(with: window)
    }
    var rootViewController: UIViewController {
        return self.window.rootViewController!
    }
}
// MARK: - CanCancelViewController
public protocol CanCancelViewController {
    var didCancel: CallBackNoParams? {get set}
    func cancel()
    func cancel(completion: (() -> Void)?)
}
public extension CanCancelViewController {
    func cancel() {
        self.cancel(completion: nil)
    }
}
private var coordinatorKey: UInt8 = 0
public extension CanCancelViewController where Self: UIViewController {
    fileprivate var _modalCoordinator: PresentedCoordinator? {
        get {return associatedObject(&coordinatorKey)}
        set {setAssociatedObject(&coordinatorKey, newValue)}
    }
    func getModalCoordinator() -> PresentedCoordinator? {
        return _modalCoordinator
    }
}
