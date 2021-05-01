//
//  UpdateNavItemProtocol.swift
//  AppExtension
//
//  Created by ZJaDe on 2018/12/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdateNavItemProtocol: AnyObject {
    /// ZJaDe: 请求
    func updateNavItem(_ navItem: UINavigationItem)
    func setNeedUpdateNavItem()
    func setNeedUpdateNavItemObserver() -> AnyObserver<Void>
}
public extension UpdateNavItemProtocol {
    func setNeedUpdateNavItemObserver() -> AnyObserver<Void> {
        AnyObserver(eventHandler: { [weak self] (event) in
            switch event {
            case .next: self?.setNeedUpdateNavItem()
            case .completed, .error: break
            }
        })
    }
}
public extension UpdateNavItemProtocol where Self: UIViewController {
    func setNeedUpdateNavItem<P: ObservableType>(_ pauser: P) where P.Element == Bool {
        setNeedUpdate(pauser, tag: "isNeedUpdateNavItem", .milliseconds(200)) {[weak self] in
            guard let self = self else { return }
            self.updateNavItem(self.navigationItem)
        }
    }
}
