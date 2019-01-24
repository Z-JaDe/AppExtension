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

extension Observable {
    /** ZJaDe:
     pauser发出true信号的时候，setNeedUpdate信号才能往下走
     delay 延迟一点时间发射信号，如果延时时间内又调用了setNeedUpdate，会重新等待delay时间
     */
    public static func setNeedUpdate<P: ObservableType>(_ pauser: P, _ delay: RxTimeInterval) -> Observable<()> where P.E == Bool {
        let observable = Observable<()>.create { (observer) -> Disposable in
                observer.onNext(())
                return Disposables.create()
            }
            .setNeedUpdate(pauser)
            .take(1)
        if delay > 0 {
            return observable.delay(delay, scheduler: MainScheduler.instance)
        } else {
            return observable
        }
    }
    private func setNeedUpdate<P: ObservableType>(_ pauser: P) -> Observable<E> where P.E == Bool {
        return pausableBuffered(pauser, flushOnCompleted: false, flushOnError: false)
    }
}
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
        let tag = "isNeedUpdateNetwork"
        let delay = disposeBagWithTag(tag) == nil ? 0 : 0.2
        self.resetDisposeBagWithTag(tag)
        Observable<Void>.setNeedUpdate(pauser, delay)
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
