//
//  UpdateNavItemProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public protocol UpdateNavItemProtocol: class {
    /// ZJaDe: 请求
    func updateNavItem(_ navItem: UINavigationItem)
    func setNeedUpdateNavItem()
    func setNeedUpdateNavItemObserver() -> AnyObserver<Void>
}
public extension UpdateNavItemProtocol {
    func setNeedUpdateNavItemObserver() -> AnyObserver<Void> {
        return AnyObserver(eventHandler: { [weak self] (event) in
            switch event {
            case .next: self?.setNeedUpdateNavItem()
            case .completed, .error: break
            }
        })
    }
}
public extension UpdateNavItemProtocol where Self: UIViewController {
    func setNeedUpdateNavItem<P: ObservableType>(_ pauser: P) where P.E == Bool {
        let tag = "isNeedUpdateNavItem"
        let delay = disposeBagWithTag(tag) == nil ? 0 : 0.2
        self.resetDisposeBagWithTag(tag)
        Observable<()>.setNeedUpdate(pauser, delay)
            .subscribeOnNext { [weak self] in
                guard let `self` = self else { return }
                self.updateNavItem(self.navigationItem)
            }.disposed(by: self.disposeBagWithTag(tag))
    }
}
