//
//  NetworkProtocol.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/12/18.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt

public protocol NetworkProtocol: class {
    /// ZJaDe: 请求
    func request()
    func setNeedRequest()
    func setNeedRequestObserver() -> AnyObserver<Void>
}
public extension NetworkProtocol {
    func setNeedRequestObserver() -> AnyObserver<Void> {
        return AnyObserver(eventHandler: { (event) in
            switch event {
            case .next: self.setNeedRequest()
            case .completed, .error: break
            }
        })
    }
}
public extension NetworkProtocol where Self: UIViewController {
    func setNeedRequest<P: ObservableType>(_ pauser: P) where P.E == Bool {
        let tag = "isNeedUpdateNetwork"
        self.resetDisposeBagWithTag(tag)
        Observable.just(())
            .pausableBuffered(pauser)
            .delay(0.5, scheduler: MainScheduler.instance)
            .subscribeOnNext { [weak self] in
                guard let `self` = self else { return }
                self.request()
            }.disposed(by: self.disposeBagWithTag(tag))
    }
}

extension UIViewController {
    /// ZJaDe: resetNetworkDisposeBag和networkDisposeBag结合可以实现多次刷新时只取最后一次的值
    public var networkDisposeBag: DisposeBag {
        return self.disposeBagWithTag("ViewControllerNetwork")
    }
    /// ZJaDe: resetNetworkDisposeBag和networkDisposeBag结合可以实现多次刷新时只取最后一次的值
    public func resetNetworkDisposeBag() {
        self.resetDisposeBagWithTag("ViewControllerNetwork")
    }
}
