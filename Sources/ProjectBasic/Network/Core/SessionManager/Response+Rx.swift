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
extension Reactive where Base: RequestContextCompatible, Base.ValueType: DataRequest {
    public func response<T: DataResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T
        ) -> RequestContextObservable<Result<T.SerializedObject>> {
        return Observable.create { observer in
            let context = self.base
            let dataRequest = context.value.response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    observer.onNext(context.map {_ in packedResponse.result})
                    observer.onCompleted()
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
extension Reactive where Base: RequestContextCompatible, Base.ValueType: DownloadRequest {
    public func response<T: DownloadResponseSerializerProtocol>(
        queue: DispatchQueue? = nil,
        responseSerializer: T
        ) -> RequestContextObservable<Result<T.SerializedObject>> {
        return Observable.create { observer in
            let context = self.base
            let dataRequest = context.value.response(queue: queue, responseSerializer: responseSerializer) { (packedResponse) -> Void in
                    observer.onNext(context.map {_ in packedResponse.result})
                    observer.onCompleted()
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}
extension ObservableType where E: RequestableContext {
    public func response() -> Observable<RequestContext<Result<Data>>> {
        return flatMapLatest { (context) -> Observable<RequestContext<Result<Data>>> in
            switch context {
            case let context as RequestContext<DataRequest>:
                return context.rx.response(responseSerializer: DataRequest.dataResponseSerializer())
            case let context as RequestContext<UploadRequest>:
                return context.rx.response(responseSerializer: UploadRequest.dataResponseSerializer())
            case let context as RequestContext<DownloadRequest>:
                return context.rx.response(responseSerializer: DownloadRequest.dataResponseSerializer())
            default: throw NetworkError.error("未实现的类型")
            }
        }
    }
}
