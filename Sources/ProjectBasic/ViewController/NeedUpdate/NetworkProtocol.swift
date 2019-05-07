//
//  NetworkProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol NetworkProtocol: class {
    /// ZJaDe: 请求
    func request()
    func setNeedRequest()
    func setNeedRequestObserver() -> AnyObserver<Void>
}
public extension NetworkProtocol {
    func setNeedRequestObserver() -> AnyObserver<Void> {
        return AnyObserver(eventHandler: { [weak self] (event) in
            switch event {
            case .next: self?.setNeedRequest()
            case .completed, .error: break
            }
        })
    }
}
public extension NetworkProtocol where Self: UIViewController {
    func setNeedRequest<P: ObservableType>(_ pauser: P) where P.E == Bool {
        setNeedUpdate(pauser, tag: "isNeedUpdateNetwork") { [weak self] in
            guard let `self` = self else { return }
            self.request()
        }
    }
}

extension UIViewController {
    /// ZJaDe: resetNetworkDisposeBag和networkDisposeBag结合可以实现多次刷新时只取最后一次的值
    public var networkDisposeBag: DisposeBag {
        return self.disposeBagWithTag("_viewControllerNetwork")
    }
    /// ZJaDe: resetNetworkDisposeBag和networkDisposeBag结合可以实现多次刷新时只取最后一次的值
    public func resetNetworkDisposeBag() {
        self.resetDisposeBagWithTag("_viewControllerNetwork")
    }
}
