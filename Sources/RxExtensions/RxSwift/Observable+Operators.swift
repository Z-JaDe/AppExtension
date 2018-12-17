//
//  Observable+Operators.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 17/3/23.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
    func then(closure: @escaping () -> Observable<E>?) -> Observable<E> {
        return then(closure: closure() ?? .empty())
    }
    func then(closure: @autoclosure @escaping () -> Observable<E>) -> Observable<E> {
        let next = Observable.deferred {
            return closure()
        }

        return self
            .concat(next)
    }
}
