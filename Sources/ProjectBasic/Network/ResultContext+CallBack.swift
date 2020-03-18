//
//  ResponseHandler.swift
//  TJS
//
//  Created by ZJaDe on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift
import RxNetwork
extension Observable where Element: RNResponseCompatible {
    public func resultCallback(_ closure: @escaping (Result<Element.Success, Error>) -> Void) -> Disposable {
        self.logDebug("_请求回调_").subscribe(onNext: { (element) in
            closure(element.result.mapError({$0}))
        }, onError: { (error) in
            closure(.failure(error))
        })
    }
}
// MARK: -
extension Observable where Element: RNResponseCompatible {
    public func valueCallback(_ closure: @escaping (Element.Success?) -> Void) -> Disposable {
        self.resultCallback { (result) in
            closure(try? result.get())
        }
    }
}
