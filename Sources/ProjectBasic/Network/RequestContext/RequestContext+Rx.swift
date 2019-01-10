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
extension ObservableType where E == RequestContext<Result<Data>> {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (RequestContext<Result<Data>>) throws -> T) -> RequestContextObservable<T> {
        return responseMap({ (context) -> T in
            return try transform(context)
        })
    }

    public func mapData() -> RequestContextObservable<Data> {
        return responseMap({ (context) -> Data in
            return try context.getData()
        })
    }
    public func mapCustomType<DataType: Decodable>(type: DataType.Type) -> RequestContextObservable<DataType> {
        return responseMap({ (context) -> DataType in
            return try context.mapCustomType()
        })
    }
    /// ZJaDe: 总入口
    private func responseMap<T>(_ transform: @escaping (RequestContext<Result<Data>>) throws -> T) -> RequestContextObservable<T> {
        return observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            /// ZJaDe: 一般这里不会抛出Error，但是外部调用的时候可能会抛出Error，可以进行一层map
            .catchError({.error($0._mapError())})
            .map({ (context) -> RequestContext<T> in
                let value = try transform(context)
                /// ZJaDe: data数据转Model
                return try context.map({_ in value})
            })
            .observeOn(MainScheduler.instance)
            .retryWhen({ $0._retryError() })
    }
}
extension ObservableType where E: RequestableContext {
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (RequestContext<Result<Data>>) throws -> T) -> RequestContextObservable<T> {
        return response().mapResultModel(transform)
    }
    public func mapData() -> RequestContextObservable<Data> {
        return response().mapData()
    }
    public func mapCustomType<DataType: Decodable>(type: DataType.Type) -> RequestContextObservable<DataType> {
        return response().mapCustomType(type: type)
    }
}
