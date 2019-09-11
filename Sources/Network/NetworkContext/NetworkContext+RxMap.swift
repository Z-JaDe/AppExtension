//
//  Observable+JSON.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/9/20.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
extension ObservableType where Element == DataResponseContext {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (Element) throws -> T) -> Observable<ResultContext<T>> {
        return responseMap({ try transform($0) })
    }
    public func mapData() -> Observable<ResultContext<Data>> {
        return responseMap({ try $0.getData() })
    }
    public func mapString() -> Observable<ResultContext<String>> {
        return responseMap({ try $0.mapString() })
    }
    public func mapImage() -> Observable<ResultContext<UIImage>> {
        return responseMap({ try $0.mapImage() })
    }
    public func map<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<ResultContext<T>> {
        return responseMap({ try $0.map(type: type, atKeyPath: keyPath) })
    }

    /// ZJaDe: 上面方法具体实现
    private func responseMap<T>(_ transform: @escaping (Element) throws -> T) -> Observable<ResultContext<T>> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            /// ZJaDe: 把Result<Data>里面的data转换成Model 同时把error抛出
            .map({ (context) -> ResultContext<T> in
                let value = try transform(context)
                /// ZJaDe: data数据转Model
                return context.map({_ in value})
            })
            .observeOn(MainScheduler.instance)
            .retryWhen({ $0._retryError() })
    }
}
extension ObservableType where Element: RequestContextCompatible {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (DataResponseContext) throws -> T) -> Observable<ResultContext<T>> {
        return response().mapResultModel(transform)
    }
    public func mapData() -> Observable<ResultContext<Data>> {
        return response().mapData()
    }
    public func mapString() -> Observable<ResultContext<String>> {
        return response().mapString()
    }
    public func mapImage() -> Observable<ResultContext<UIImage>> {
        return response().mapImage()
    }
    public func map<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<ResultContext<T>> {
        return response().map(type: type, atKeyPath: keyPath)
    }
}
