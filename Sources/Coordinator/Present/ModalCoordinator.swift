//
//  ModalCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
public protocol ModalCoordinatorProtocol {
    associatedtype ViewConType: UIViewController
    func createViewCon() -> ViewConType
    func start(in viewCon: ViewConType)
    init()
}
public extension ModalCoordinatorProtocol {
    static func create() -> (coor: Self, viewCon: ViewConType) {
        let coor = self.init()
        return (coor, coor.createViewCon())
    }
}
/// ZJaDe: 可以被modal出来的 协调器
public typealias AbstractModalCoordinator = PresentedCoordinator & RootViewControllerProvider

open class ModalCoordinator<ViewConType>: AbstractModalCoordinator,
    CanPresentProtocol,
    AssociatedRootViewControllerProvider,
    ModalCoordinatorProtocol
where ViewConType: CanCancelModalViewController & UIViewController {

    public private(set) weak var viewCon: ViewConType? {
        didSet {
            oldValue?.coordinator = nil
            self.viewCon?.coordinator = self
        }
    }
    open func createViewCon() -> ViewConType {
        let viewCon = ViewConType()
        self.viewCon = viewCon
        return viewCon
    }

    open func start(in viewCon: ViewConType) {
    }
    open func didCancel() {

    }
    public func cancel(completion: (() -> Void)? = nil) {
        self.viewCon?.cancel(completion: completion)
    }
}
