//
//  NeedUpdate.swift
//  AppExtension
//
//  Created by Apple on 2019/5/7.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

extension Observable {
    /** ZJaDe:
     pauser发出true信号的时候，setNeedUpdate信号才能往下走
     */
    public static func setNeedUpdate<P: ObservableType>(_ pauser: P, _ delay: RxTimeInterval) -> Observable<Void> where P.Element == Bool {
        let observable: Observable<Bool>
        if delay != .seconds(0) {
            observable = pauser.throttle(delay, scheduler: MainScheduler.instance)
        } else {
            observable = pauser.asObservable()
        }
        return observable.filterTrue().take(1)
    }
}
extension DisposeBagProtocol {
    /** ZJaDe:
    pauser发出true信号的时候，setNeedUpdate信号才能往下走
    delay 如果delay时间内又调用了setNeedUpdate，会重新等待delay时间
    */
    public func setNeedUpdate<P: ObservableType>(_ pauser: P, tag: String, _ delay: RxTimeInterval, updater: @escaping () -> Void) where P.Element == Bool {
        let delay: RxTimeInterval = optionalDisposeBagWithTag(tag) == nil ? .milliseconds(0) : delay
        let disposeBag = self.resetDisposeBagWithTag(tag)
        Observable<Void>.setNeedUpdate(pauser, delay)
            .subscribeOnNext(updater)
            .disposed(by: disposeBag)
    }
}
