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
extension ObservableType where E == RequestContext<DataRequest> {
    public typealias RequestContextResult<T> = RequestContext<Result<T>>
    public typealias RequestContextResultData = RequestContextResult<Data>
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (RequestContextResultData) throws -> T) -> RequestContextObservable<T> {
        return responseFlatMap({ (context) -> T in
            return try transform(context)
        })
    }

    public func mapCustomType<DataType: Decodable>(type: DataType.Type) -> RequestContextObservable<DataType> {
        return responseFlatMap({ (context) -> DataType in
            return try context.mapCustomType()
        })
    }
    private func responseFlatMap<T>(_ transform: @escaping (RequestContextResultData) throws -> T) -> RequestContextObservable<T> {
        return response()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map({ (context) -> RequestContext<T> in
                /// ZJaDe: data数据转Model
                return try context.map({_ in try transform(context)})
            })
            .observeOn(MainScheduler.instance)
            .retryWhen({ $0._retryError() })
    }
}

