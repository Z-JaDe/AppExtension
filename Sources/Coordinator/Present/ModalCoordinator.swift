//
//  ModalCoordinator.swift
//  Wallet
//
//  Created by 郑军铎 on 2018/11/1.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
public protocol ModalCoordinatorCompatible: Coordinator, CoordinatorContainer, Presentable, AbstractPresentItemConvertible {
    init()
    var viewCon: PresentItemType? {get}
    func createViewCon() -> PresentItemType
    func start(in viewCon: PresentItemType)
}
public extension ModalCoordinatorCompatible {
    public var presentItemViewCon: PresentItemType? {
        viewCon
    }
    static func create() -> (coor: Self, viewCon: PresentItemType) {
        let coor = self.init()
        return (coor, coor.createViewCon())
    }
}
/// ZJaDe: 可以被modal出来的 协调器
open class ModalCoordinator<PresentItemType: UIViewController>: ModalCoordinatorCompatible {

    public required init() {}
    public var coordinators: [Coordinator] = []
    public private(set) weak var viewCon: PresentItemType? {
        didSet {
            oldValue?.coordinator = nil
            self.viewCon?.coordinator = self
        }
    }
    open func createViewCon() -> PresentItemType {
        let viewCon = PresentItemType()
        self.viewCon = viewCon
        return viewCon
    }

    open func start(in viewCon: PresentItemType) {
    }
    open func didCancel() {

    }
}
extension ModalCoordinator where PresentItemType: CanCancelModalViewController {
    public func cancel(completion: (() -> Void)? = nil) {
        self.viewCon?.cancel(completion: completion)
    }
}
