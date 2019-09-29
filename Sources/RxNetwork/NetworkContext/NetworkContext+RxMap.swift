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
extension ObservableType where Element == DataResultContext {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (Element) throws -> T) -> Observable<ResponseContext<T>> {
        responseMap({ try transform($0) })
    }
    public func mapData() -> Observable<ResponseContext<Data>> {
        responseMap({ try $0.getData() })
    }
    public func mapString() -> Observable<ResponseContext<String>> {
        responseMap({ try $0.mapString() })
    }
    public func mapImage() -> Observable<ResponseContext<UIImage>> {
        responseMap({ try $0.mapImage() })
    }
    public func map<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<ResponseContext<T>> {
        responseMap({ try $0.map(type: type, atKeyPath: keyPath) })
    }

    /// ZJaDe: 上面方法具体实现
    private func responseMap<T>(_ transform: @escaping (Element) throws -> T) -> Observable<ResponseContext<T>> {
        observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            /// ZJaDe: 把Result<Data>里面的data转换成Model 同时把error抛出
            .map({ (context) -> ResponseContext<T> in
                do {
                    let value = try transform(context)
                    /// ZJaDe: data数据转Model
                    return context.map({_ in value})
                } catch let error {
                    /// ZJaDe: 如果是可以重新请求的Error则直接抛出，如果不是就转换成Result
                    if error is RetryRequestProtocol {
                        throw error
                    } else {
                        return context.map({_ in throw error})
                    }
                }
            })
            .observeOn(MainScheduler.instance)
            .retryWhen({ $0._retryError() })
    }
}
extension ObservableType where Element: RequestContextCompatible {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (DataResultContext) throws -> T) -> Observable<ResponseContext<T>> {
        response().mapResultModel(transform)
    }
    public func mapData() -> Observable<ResponseContext<Data>> {
        response().mapData()
    }
    public func mapString() -> Observable<ResponseContext<String>> {
        response().mapString()
    }
    public func mapImage() -> Observable<ResponseContext<UIImage>> {
        response().mapImage()
    }
    public func map<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<ResponseContext<T>> {
        response().map(type: type, atKeyPath: keyPath)
    }
}
