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
extension ObservableType where E: RequestableContext {
    public typealias RequestContextResult<T> = RequestContext<Result<T>>
    public typealias RequestContextResultData = RequestContextResult<Data>
    public func mapResultModel<T: AbstractResultModelType>(_ transform: @escaping (RequestContextResultData) throws -> T) -> RequestContextObservable<T> {
        return responseFlatMap({ (context) -> T in
            return try transform(context)
        })
    }

    public func mapData() -> RequestContextObservable<Data> {
        return responseFlatMap({ (context) -> Data in
            return try context.getData()
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
extension ObservableType where E: RequestableContext {
    internal func response() -> Observable<RequestContextResultData> {
        return flatMapLatest { (context) -> Observable<RequestContextResultData> in
            switch context {
            case let context as RequestContext<DataRequest>:
                return context.rx.response(responseSerializer: DataRequest.dataResponseSerializer())
            case let context as RequestContext<DownloadRequest>:
                return context.rx.response(responseSerializer: DownloadRequest.dataResponseSerializer())
            default: throw NetworkError.error("未实现的类型")
            }
        }
    }
}
