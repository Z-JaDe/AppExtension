//
//  Store+Rx.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/7.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
#if canImport(RxSwift) && canImport(ReSwift)
import ReSwift
import RxSwift

extension Store {
    open func rxSubscribe<S: StoreSubscriber>(_ subscriber: S) -> Disposable
        where S.StoreSubscriberStateType == State {
            self.subscribe(subscriber)
            return Disposables.create {
                self.unsubscribe(subscriber)
            }
    }

    open func rxSubscribe<SelectedState: Equatable, S: StoreSubscriber>(
        _ subscriber: S, transform: ((Subscription<State>) -> Subscription<SelectedState>)?
        ) -> Disposable where S.StoreSubscriberStateType == SelectedState {
        self.subscribe(subscriber, transform: transform)
        return Disposables.create {
            self.unsubscribe(subscriber)
        }
    }
}
extension Store {
    // ZJaDe: 不遵循Equatable的不建议用
    //    open func observe<SelectedState>(_ selector: @escaping (State) -> SelectedState) -> Observable<SelectedState> {
    //        return Observable.create({ (observer) -> Disposable in
    //            let subscriber = AnonymousStoreSubscriber<SelectedState>({ (state) in
    //                observer.onNext(state)
    //            })
    //            return self.rxSubscribe(subscriber, transform: {$0.select(selector)})
    //        })
    //    }
    open func observe<SelectedState: Equatable>(_ selector: @escaping (State) -> SelectedState) -> Observable<SelectedState> {
        Observable.create({ (observer) -> Disposable in
            let subscriber = AnonymousStoreSubscriber<SelectedState>({ (state) in
                observer.onNext(state)
            })
            return self.rxSubscribe(subscriber, transform: {$0.select(selector)})
        })
    }
}
private class AnonymousStoreSubscriber<SelectedState>: StoreSubscriber {
    typealias ClosureType = (SelectedState) -> Void
    let closure: ClosureType
    init(_ closure: @escaping ClosureType) {
        self.closure = closure
    }
    func newState(state: SelectedState) {
        self.closure(state)
    }
}
#endif
