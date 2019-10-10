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
                    return context.map({_ in throw error})
                }
            })
            .observeOn(MainScheduler.instance)
    }
}
extension ObservableType where Element: RequestContextCompatible {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (DataResultContext) throws -> T) -> Observable<ResponseContext<T>> {
        responseData().mapResultModel(transform)
    }
    public func map<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<ResponseContext<T>> {
        responseData().map(type: type, atKeyPath: keyPath)
    }
}
