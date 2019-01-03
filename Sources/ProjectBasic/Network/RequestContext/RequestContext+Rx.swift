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
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (RequestContext<Data>) throws -> T) -> RequestContextObservable<T> {
        return response()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            /// ZJaDe: Alamofire请求后catchError
            .catchError { .error(($0 as? MapErrorProtocol)?.mapError() ?? $0) }
            /// ZJaDe: data数据转resultModel
            .map({ (context) -> RequestContext<T> in
                return try context.map({_ in try transform(context)})
            })
            .observeOn(MainScheduler.instance)
            .retryWhen({ (error) -> Observable<()> in
                return error.flatMapLatest({ (error) -> Observable<()> in
                    if let error = error as? RetryRequestProtocol {
                        return error.retryError()
                    } else {
                        throw error
                    }
                })
            })
    }

    public func mapCustomType<DataType: Decodable>(type: DataType.Type) -> RequestContextObservable<DataType> {
        return response()
            .map({ (context) -> RequestContext<DataType> in
            return try context.map({_ in try context.mapCustomType()})
            })
            .observeOn(MainScheduler.instance)
    }
}
