//
//  UIViewController+ViewState.swift
//  AppExtensionTests
//
//  Created by ZJaDe on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public protocol RootViewStateProtocol: class {
    var viewState: BehaviorSubject<RootViewState> {get}
}

private var viewStateKey: UInt8 = 0
public extension RootViewStateProtocol where Self: UIViewController {
    var viewState: BehaviorSubject<RootViewState> {
        associatedObject(&viewStateKey, createIfNeed: BehaviorSubject(value: .viewNoLoad))
    }
}

public extension Reactive where Base: UIViewController & RootViewStateProtocol {
    // MARK: - 下面几个关于viewState的信号 默认会调用distinctUntilChanged 每次发送的信号都和上次的不同
    /// ZJaDe: 每次界面将要出现会发送一次信号
    func whenAppear() -> Observable<()> {
        self.isAppear.filter({$0}).mapToVoid()
    }
    /// ZJaDe: 每次界面已经出现会发送一次信号
    func whenDidAppear() -> Observable<()> {
        self.isDidAppear.filter({$0}).mapToVoid()
    }
    /// ZJaDe: 每次界面将要出现会发送一次信号
    func whenDisAppear() -> Observable<()> {
        self.isDidAppear.filter({$0}).mapToVoid()
    }
    /// ZJaDe: 每次界面已经出现会发送一次信号
    func whenDidDisAppear() -> Observable<()> {
        self.isDidDisAppear.filter({$0}).mapToVoid()
    }

    /// ZJaDe: 每次界面将要出现和将要消失的时候会发送一次信号
    var isAppear: Observable<Bool> {
        self.checkViewState {$0.isAppear}
    }
    /// ZJaDe: 每次界面已经出现和将要消失的时候会发送一次信号
    var isDidAppear: Observable<Bool> {
        self.checkViewState {$0.isDidAppear}
    }
    /// ZJaDe: 每次界面将要出现和将要消失的时候会发送一次信号
    var isDisAppear: Observable<Bool> {
        self.checkViewState {$0.isDisappear}
    }
    /// ZJaDe: 每次界面已经出现和将要消失的时候会发送一次信号
    var isDidDisAppear: Observable<Bool> {
        self.checkViewState {$0.isDidDisappear}
    }

    /// ZJaDe: viewState符合时会发送一次信号
    func whenViewState(_ viewState: RootViewState) -> Observable<()> {
        self.checkViewState({$0 == viewState}).filter({$0}).mapToVoid()
    }
    /// ZJaDe: viewState符合和不符合时分别会发送一次信号
    internal func checkViewState(_ transform: @escaping (RootViewState) -> Bool) -> Observable<Bool> {
        self.base.viewState.map(transform)
            .distinctUntilChanged()
    }

}
public extension Reactive where Base: UIViewController & RootViewStateProtocol {
    var dismissed: ControlEvent<Void> {
        let dismissedSource = self.isDidDisAppear
            .filter { [base] in $0 && base.isBeingDismissed }
            .mapToVoid()
        let movedToParentSource = self.sentMessage(#selector(Base.didMove))
            .filter({($0.first is UIViewController) == false})
            .mapToVoid()
        return ControlEvent(events: Observable.merge(dismissedSource, movedToParentSource))
    }
    var firstTimeViewDidAppear: Maybe<Void> {
        self.isDidAppear
            .filterTrue()
            .take(1).asMaybe()
    }
}
