//
//  Presentable.swift
//  NavigationFlow
//
//  Created by 郑军铎 on 2018/12/17.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift

public protocol Presentable: DisposeBagProtocol {
    var rxVisible: Observable<Bool> { get }
    var rxFirstTimeVisible: Single<Void> { get }
    var rxDismissed: Single<Void> { get }
}
extension UIWindow: Presentable {}
// MARK: -
extension Presentable where Self: UIViewController & RootViewStateProtocol {
    public var rxVisible: Observable<Bool> {
        self.rx.isDidAppear
    }
    public var rxFirstTimeVisible: Single<Void> {
        self.rx.firstTimeViewDidAppear
    }
    public var rxDismissed: Single<Void> {
        self.rx.dismissed.take(1).asSingle()
    }
}
extension Presentable where Self: Flow {
    public var rxVisible: Observable<Bool> {
        self.root.rxVisible
    }
    public var rxFirstTimeVisible: Single<Void> {
        self.root.rxFirstTimeVisible
    }
    public var rxDismissed: Single<Void> {
        self.root.rxDismissed
    }
}
extension Presentable where Self: UIWindow {
    public var rxFirstTimeVisible: Single<Void> {
        self.rx.windowDidAppear.take(1).asSingle()
    }
    public var rxVisible: Observable<Bool> {
        self.rx.windowDidAppear.asObservable().map { true }
    }
    public var rxDismissed: Single<Void> {
        Single.never()
    }
}
