//
//  NavItemCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation

open class HasNavCoordinator: NSObject, Coordinator, CoordinatorContainer {
    public var coordinators: [Coordinator] = []
    public weak var navCon: UINavigationController?
    public required init(_ navCon: UINavigationController?) {
        self.navCon = navCon
    }
    /// 手动调用
    open func startNoViewCon() {

    }
}
extension HasNavCoordinator: NavJumpable {
    public func asNavigationController() -> UINavigationController? {
        navCon
    }
}
// MARK: -
public protocol NavItemCoordinatorCompatible: NavJumpable, AbstractNavItemConvertible {
    init(_ navCon: UINavigationController?)
    var viewCon: NavItemType? {get}
    func createViewCon() -> NavItemType
    func start(in viewCon: NavItemType)
}
public extension NavItemCoordinatorCompatible {
    var navItemViewCon: NavItemType? {
        viewCon
    }
    static func create(_ navCon: UINavigationController?) -> (coordinator: Self, viewCon: NavItemType) {
        let coordinator = self.init(navCon)
        return (coordinator, coordinator.createViewCon())
    }
}
/// ZJaDe: nav流程中的一个 item
open class NavItemCoordinator<NavItemType: UIViewController>: HasNavCoordinator, NavItemCoordinatorCompatible {

    open func start(in viewCon: NavItemType) {

    }

    public private(set) weak var viewCon: NavItemType? {
        didSet {
            oldValue?.coordinator = nil
            self.viewCon?.coordinator = self
        }
    }

    open func createViewCon() -> NavItemType {
        let viewCon = NavItemType()
        self.viewCon = viewCon
        return viewCon
    }
}
extension NavItemCoordinator: PresentItemConvertible {
    public func asPresentItem() -> UIViewController? {
        viewCon
    }
}
