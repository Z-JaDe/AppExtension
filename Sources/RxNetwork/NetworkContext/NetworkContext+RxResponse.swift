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

extension ObservableType where Element: RequestContextCompatible, Element.Value: DataRequest {
    public func response(queue: DispatchQueue = .main) -> Observable<ResponseContext<Data?>> {
        flatMapLatest {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, completionHandler: completionHandler)
            }
        }
    }
    public func response<T: DataResponseSerializerProtocol>(queue: DispatchQueue = .main, responseSerializer: T) -> Observable<ResponseContext<T.SerializedObject>> {
        flatMapLatest {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
            }
        }
    }
}
extension ObservableType where Element: RequestContextCompatible, Element.Value: DownloadRequest {
    public func response(queue: DispatchQueue = .main) -> Observable<ResponseContext<URL?>> {
        flatMapLatest {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, completionHandler: completionHandler)
            }
        }
    }
    public func response<T: DownloadResponseSerializerProtocol>(queue: DispatchQueue = .main, responseSerializer: T) -> Observable<ResponseContext<T.SerializedObject>> {
        flatMapLatest {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
            }
        }
    }
}

extension ObservableType where Element: RequestContextCompatible {
    /// ZJaDe: 请求返回Result<Data>结果。冷信号，该方法被订阅时，才会真正添加请求任务
    public func responseData() -> Observable<DataResultContext> {
        flatMapLatest { (context) -> Observable<DataResultContext> in
            switch context {
            case let context as RequestContext<UploadRequest>:
                return context.asObservable { (context, completionHandler) in
                    context.value.response(responseSerializer: DataResponseSerializer(), completionHandler: completionHandler)
                }
            case let context as RequestContext<DataRequest>:
                return context.asObservable { (context, completionHandler) in
                    context.value.response(responseSerializer: DataResponseSerializer(), completionHandler: completionHandler)
                }
            case let context as RequestContext<DownloadRequest>:
                return context.asObservable { (context, completionHandler) in
                    context.value.response(responseSerializer: DataResponseSerializer(), completionHandler: completionHandler)
                }
            default: throw NetworkError.error("未实现的类型")
            }
        }
    }
}

extension RequestContextCompatible where Value: DataRequest {
    typealias DataResponseFunc<V> = (Self, @escaping (AFDataResponse<V>) -> Void) -> Void
    func asObservable<V>(_ responseFunc: @escaping DataResponseFunc<V>) -> Observable<ResponseContext<V>> {
        Observable.create { observer in
            responseFunc(self) { (response) -> Void in
                observer.onNext(self.mapResponse({_ in response}))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
extension RequestContextCompatible where Value: DownloadRequest {
    typealias DownloadResponseFunc<V> = (Self, @escaping (AFDownloadResponse<V>) -> Void) -> Void
    func asObservable<V>(_ responseFunc: @escaping DownloadResponseFunc<V>) -> Observable<ResponseContext<V>> {
        Observable.create { observer in
            responseFunc(self) { (response) -> Void in
                observer.onNext(self.mapResponse({_ in response}))
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
