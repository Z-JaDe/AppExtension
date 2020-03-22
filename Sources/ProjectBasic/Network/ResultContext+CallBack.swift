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
        var stopped = false
        return self.logDebug("_请求回调_").subscribe(onNext: { (element) in
            if stopped { return }; stopped = true
            closure(element.result.mapError({$0}))
        }, onError: { (error) in
            if stopped { return }; stopped = true
            closure(.failure(error._mapError()))
        }, onCompleted: {
            if stopped { return }; stopped = true
            closure(.failure(NetworkError.noData))
        })
    }
    public func valueCallback(_ closure: @escaping (Element.Success?) -> Void) -> Disposable {
        resultCallback { (result) in
            closure(try? result.get())
        }
    }
}
// MARK: -
extension PrimitiveSequence where Trait == SingleTrait, Element: RNResponseCompatible {
    public func resultCallback(_ closure: @escaping (Result<Element.Success, Error>) -> Void) -> Disposable {
        self.logDebug("_请求回调_").subscribe(onSuccess: { (element) in
            closure(element.result.mapError({$0}))
        }, onError: { (error) in
            closure(.failure(error._mapError()))
        })
    }
    public func valueCallback(_ closure: @escaping (Element.Success?) -> Void) -> Disposable {
        resultCallback { (result) in
            closure(try? result.get())
        }
    }
}
extension PrimitiveSequence where Trait == MaybeTrait, Element: RNResponseCompatible {
    public func resultCallback(_ closure: @escaping (Result<Element.Success, Error>) -> Void) -> Disposable {
        self.logDebug("_请求回调_").subscribe(onSuccess: { (element) in
            closure(element.result.mapError({$0}))
        }, onError: { (error) in
            closure(.failure(error._mapError()))
        }, onCompleted: {
            closure(.failure(NetworkError.noData))
        })
    }
    public func valueCallback(_ closure: @escaping (Element.Success?) -> Void) -> Disposable {
        self.resultCallback { (result) in
            closure(try? result.get())
        }
    }
}
