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