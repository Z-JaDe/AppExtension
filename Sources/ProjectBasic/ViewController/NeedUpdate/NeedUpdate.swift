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
     delay debounce防抖动
     */
    public static func setNeedUpdate<P: ObservableType>(_ pauser: P, _ delay: RxTimeInterval) -> Observable<Void> where P.Element == Bool {
        Observable<Void>.create { (observer) -> Disposable in
            let observable: Observable<Bool>
            if delay != .seconds(0) {
                observable = pauser.debounce(delay, scheduler: MainScheduler.asyncInstance)
            } else {
                observable = pauser.asObservable()
            }
            var isSend: Bool = false
            let disposable = observable.subscribeOnNext { (resume) in
                if resume && isSend == false {
                    isSend = true
                    observer.onNext(())
                    observer.onCompleted()
                } else if isSend {
                    observer.onCompleted()
                }
            }
            return Disposables.create([disposable])
        }
    }
}
extension DisposeBagProtocol {
    /** ZJaDe:
    pauser发出true信号的时候，setNeedUpdate信号才能往下走
    delay debounce防抖动，同时如果delay时间内又调用了setNeedUpdate，会重新等待delay时间
    */
    public func setNeedUpdate<P: ObservableType>(_ pauser: P, tag: String, _ delay: RxTimeInterval, updater: @escaping () -> Void) where P.Element == Bool {
        let delay: RxTimeInterval = optionalDisposeBagWithTag(tag) == nil ? .milliseconds(0) : delay
        let disposeBag = self.resetDisposeBagWithTag(tag)
        Observable<Void>.setNeedUpdate(pauser, delay)
            .subscribeOnNext(updater)
            .disposed(by: disposeBag)
    }
}
