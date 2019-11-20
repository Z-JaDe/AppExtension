//
//  ObservableType.swift
//  JDKit
//
//  Created by ZJaDe on 2017/11/23.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public enum ErrorEventHandle {
    case error
    case complete
    case never
}

public extension ObservableType {
    func mapToVoid() -> Observable<()> {
        map {_ in ()}
    }
    func mapToOptional() -> Observable<Element?> {
        map { Optional($0) }
    }
}
public extension ObservableType where Element == Bool {
    func filterTrue() -> Observable<Void> {
        filter({$0}).mapToVoid()
    }
}
public extension ObservableType where Element: Equatable {
    func ignore(values valuesToIgnore: Element...) -> Observable<Element> {
        return self.asObservable().filter { !valuesToIgnore.contains($0) }
    }
}
// MARK: - subscribe
extension ObservableType {
    public func subscribeOnNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        subscribe(onNext: onNext, onError: { error in
            logError("订阅失败 error: \(error)")
        })
    }
}
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    public func driveOnNext(_ onNext: @escaping (Element) -> Void) -> Disposable {
        drive(onNext: onNext)
    }
}
