//
//  ResponseHandler.swift
//  TJS
//
//  Created by 郑军铎 on 2018/5/10.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: ResponseContextCompatible {
    public func resultCallback(_ closure: @escaping (Element.Result) -> Void) -> Disposable {
        self.logDebug("_请求回调_").subscribe(onNext: { (element) in
            closure(element.result)
        }, onError: { (error) in
            closure(Element.Result.failure(.unknown(error)))
        })
    }
}
// MARK: -
extension Observable where Element: ResponseContextCompatible {
    public func valueCallback(_ closure: @escaping (Element.Value?) -> Void) -> Disposable {
        self.resultCallback { (result) in
            closure(try? result.get())
        }
    }
}
