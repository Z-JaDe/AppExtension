//
//  ObservableType.swift
//  JDKit
//
//  Created by 茶古电子商务 on 2017/11/23.
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

extension ObservableType {
    public func mapToVoid() -> Observable<()> {
        return map {_ in ()}
    }
    func mapToOptional() -> Observable<E?> {
        return map { Optional($0) }
    }
}
extension ObservableType where E == Bool {
    func filterTrue() -> Observable<Void> {
        return filter({$0}).mapToVoid()
    }
}
extension ObservableType where E: Equatable {
    func ignore(value: E) -> Observable<E> {
        return filter { (e) -> Bool in
            return value != e
        }
    }
}
// MARK: - subscribe
extension ObservableType {
    public func subscribeOnNext(_ onNext: @escaping (E) -> Void) -> Disposable {
        return subscribe(onNext: onNext, onError: { error in
            logError("订阅失败 error: \(error)")
        })
    }
}
extension SharedSequenceConvertibleType where SharingStrategy == DriverSharingStrategy {
    public func driveOnNext(_ onNext: @escaping (E) -> Void) -> Disposable {
        return drive(onNext: onNext)
    }
}
