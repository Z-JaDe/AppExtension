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
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, completionHandler: completionHandler)
            }
        }
    }
    public func response<T: DataResponseSerializerProtocol>(queue: DispatchQueue = .main, responseSerializer: T) -> Observable<ResponseContext<T.SerializedObject>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
            }
        }
    }
}
extension ObservableType where Element: RequestContextCompatible, Element.Value: DownloadRequest {
    public func response(queue: DispatchQueue = .main) -> Observable<ResponseContext<URL?>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, completionHandler: completionHandler)
            }
        }
    }
    public func response<T: DownloadResponseSerializerProtocol>(queue: DispatchQueue = .main, responseSerializer: T) -> Observable<ResponseContext<T.SerializedObject>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.value.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
            }
        }
    }
}

let dataResponseSerializer = DataResponseSerializer()

extension ObservableType where Element: RequestContextCompatible {
    /// ZJaDe: 请求返回Result<Data>结果。冷信号，该方法被订阅时，才会真正添加请求任务
    public func responseData() -> Observable<DataResultContext> {
        flatMapNetwork { (context) -> Observable<DataResultContext> in
            switch context {
            case let context as RequestContext<UploadRequest>:
                return context.asObservable { (context, completionHandler) in
                    context.value.response(responseSerializer: dataResponseSerializer, completionHandler: completionHandler)
                }
            case let context as RequestContext<DataRequest>:
                return context.asObservable { (context, completionHandler) in
                    context.value.response(responseSerializer: dataResponseSerializer, completionHandler: completionHandler)
                }
            case let context as RequestContext<DownloadRequest>:
                return context.asObservable { (context, completionHandler) in
                    context.value.response(responseSerializer: dataResponseSerializer, completionHandler: completionHandler)
                }
            default: throw NetworkError.error("未实现的类型")
            }
        }
    }
}

///flatMapLatest内部接收到最终数据后，通过NetworkStateError结束整个信号流
enum NetworkStateError: Swift.Error {
    case end
}
extension ObservableType where Element: RequestContextCompatible {
    func flatMapNetwork<Source: ObservableConvertibleType>(_ selector: @escaping (Element) throws -> Source)
        -> Observable<Source.Element> {
            flatMapLatest(selector).catchError { (error) -> Observable<Source.Element> in
                if case .end = error as? NetworkStateError {
                    return Observable.empty()
                }
                throw error
            }
    }
}
extension RequestContextCompatible where Value: DataRequest {
    typealias DataResponseFunc<V> = (Self, @escaping (AFDataResponse<V>) -> Void) -> Void
    func asObservable<V>(_ responseFunc: @escaping DataResponseFunc<V>) -> Observable<ResponseContext<V>> {
        Observable.create { observer in
            responseFunc(self) { (response) -> Void in
                observer.onNext(self.mapResponse({_ in response}))
                observer.onError(NetworkStateError.end)
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
                observer.onError(NetworkStateError.end)
            }
            return Disposables.create()
        }
    }
}
