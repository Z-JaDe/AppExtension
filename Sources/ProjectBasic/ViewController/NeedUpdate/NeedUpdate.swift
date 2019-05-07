//
//  NeedUpdate.swift
//  AppExtension
//
//  Created by Apple on 2019/5/7.
//  Copyright © 2019 ZJaDe. All rights reserved.
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
extension NSObject {
    public func setNeedUpdate<P: ObservableType>(_ pauser: P, tag: String, updater: @escaping () -> Void) where P.E == Bool {
        let delay = disposeBagWithTag(tag) == nil ? 0 : 0.2
        let disposeBag = self.resetDisposeBagWithTag(tag)
        Observable<()>.setNeedUpdate(pauser, delay)
            .subscribeOnNext(updater)
            .disposed(by: disposeBag)
    }
}
