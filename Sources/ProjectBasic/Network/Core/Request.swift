//
//  Request.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

extension RequestContext: ReactiveCompatible {}
// MARK: -
extension Reactive where Base == RequestContext<DataRequest> {
    public func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T
        ) -> RequestContextObservable<Result<T.SerializedObject>> {
        return Observable.create { observer in
            let context = self.base
            let dataRequest = context.value
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    observer.onNext(context.map {_ in packedResponse.result})
                    observer.onCompleted()
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
extension ObservableType where E == RequestContext<DataRequest> {
    public func response() -> Observable<RequestContextResultData> {
        return flatMap { $0.rx.response(responseSerializer: E.ValueType.dataResponseSerializer()) }
    }
}
// MARK: -
extension Reactive where Base == RequestContext<DownloadRequest> {
    public func response<T: DownloadResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T
        ) -> RequestContextObservable<Result<T.SerializedObject>> {
        return Observable.create { observer in
            let context = self.base
            let dataRequest = context.value
                .response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    observer.onNext(context.map {_ in packedResponse.result})
                    observer.onCompleted()
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
extension ObservableType where E == RequestContext<DownloadRequest> {
    public func response() -> Observable<RequestContextResultData> {
        return flatMap { $0.rx.response(responseSerializer: E.ValueType.dataResponseSerializer()) }
    }
}
