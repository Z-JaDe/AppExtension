//
//  Request.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

extension ObservableType where Element: RequestContextCompatible, Element.R: DataRequest {
    public func response(queue: DispatchQueue = .main) -> Observable<DataResponseContext<Data?>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.request.response(queue: queue, completionHandler: completionHandler)
            }
        }
    }
    public func response<T: DataResponseSerializerProtocol>(queue: DispatchQueue = .main, responseSerializer: T) -> Observable<DataResponseContext<T.SerializedObject>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.request.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
            }
        }
    }
}
extension ObservableType where Element: RequestContextCompatible, Element.R: DownloadRequest {
    public func cancel() -> Observable<Data?> {
        flatMapNetwork { (context) -> Observable<Data?> in
            Observable.create { observer in
                context.request.cancel { (resumeData) in
                    observer.onNext(resumeData)
                    observer.onError(NetworkStateError.end)
                }
                return Disposables.create()
            }
        }
    }
    public func response(queue: DispatchQueue = .main) -> Observable<DownloadResponseContext<URL?>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.request.response(queue: queue, completionHandler: completionHandler)
            }
        }
    }
    public func response<T: DownloadResponseSerializerProtocol>(queue: DispatchQueue = .main, responseSerializer: T) -> Observable<DownloadResponseContext<T.SerializedObject>> {
        flatMapNetwork {
            $0.asObservable { (context, completionHandler) in
                context.request.response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
            }
        }
    }
}

///flatMapLatest内部接收到最终数据后，通过NetworkStateError结束整个信号流
private enum NetworkStateError: Swift.Error {
    case end
}
extension ObservableType where Element: RequestContextCompatible {
    private func flatMapNetwork<Source: ObservableConvertibleType>(_ selector: @escaping (Element) -> Source)
        -> Observable<Source.Element> {
            flatMapLatest(selector).catchError { (error) -> Observable<Source.Element> in
                if case .end = error as? NetworkStateError {
                    return Observable.empty()
                }
                /// 一般不会走这里 有些信号是外部接进来的，还是有可能会出现的
                throw error._mapError()
            }
    }
}
extension RequestContextCompatible where R: DataRequest {
    typealias DataResponseFunc<V> = (Self, @escaping (AFDataResponse<V>) -> Void) -> Void
    func asObservable<V>(_ responseFunc: @escaping DataResponseFunc<V>) -> Observable<DataResponseContext<V>> {
        Observable.create { observer in
            responseFunc(self) { (response) -> Void in
                observer.onNext(self.mapResponse({_ in response}))
                observer.onError(NetworkStateError.end)
            }
            return Disposables.create()
        }
    }
}
extension RequestContextCompatible where R: DownloadRequest {
    typealias DownloadResponseFunc<V> = (Self, @escaping (AFDownloadResponse<V>) -> Void) -> Void
    func asObservable<V>(_ responseFunc: @escaping DownloadResponseFunc<V>) -> Observable<DownloadResponseContext<V>> {
        Observable.create { observer in
            responseFunc(self) { (response) -> Void in
                observer.onNext(self.mapResponse({_ in response}))
                observer.onError(NetworkStateError.end)
            }
            return Disposables.create()
        }
    }
}
