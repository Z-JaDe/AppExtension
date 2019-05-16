//
//  AbstractNavItemCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
public protocol NavItemCoordinatorProtocol {
    associatedtype ViewConType: UIViewController
    func createViewCon() -> ViewConType
    func start(in viewCon: ViewConType)
    init(_ navCon: UINavigationController?)
}
public extension NavItemCoordinatorProtocol {
    static func create(_ navCon: UINavigationController?) -> (coor: Self, viewCon: ViewConType) {
        let coor = self.init(navCon)
        return (coor, coor.createViewCon())
    }
}
/// ZJaDe: nav流程中的一个 item
public typealias AbstractNavItemCoordinator = HasNavConCoordinator & CanPresentProtocol

open class NavItemCoordinator<ViewConType>: AbstractNavItemCoordinator,
    AssociatedViewControllerConvertible,
    NavItemCoordinatorProtocol
    where ViewConType: UIViewController {

    open func start(in viewCon: ViewConType) {

    }

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
}
