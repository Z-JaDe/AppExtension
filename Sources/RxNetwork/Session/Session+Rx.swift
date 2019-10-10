//
//  Session.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
#if canImport(RxSwiftExt)
import RxSwiftExt
#endif
import Alamofire
/** ZJaDe:
 订阅Request消息后，请求会开始发送，
 在response、progress或者map方法里面可以截取到获取的数据
 */
// MARK: -

extension Session: ReactiveCompatible {}
extension Reactive where Base: Session {
    // MARK: Request
    public func request(_ method: HTTPMethod,
                        _ url: URLConvertible,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil,
                        interceptor: RequestInterceptor? = nil) -> Observable<RequestContext<DataRequest>> {
        getRequest { $0.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, interceptor: interceptor) }
            .map { RequestContext($0, $0.request) }
    }
    public func request(_ urlRequest: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> Observable<RequestContext<DataRequest>> {
        getRequest { $0.request(urlRequest, interceptor: interceptor) }
            .map { RequestContext($0, urlRequest) }
    }
    // MARK: Upload
    public func upload(
        multipartFormData: @escaping (MultipartFormData) -> Void,
        with request: URLRequestConvertible,
        usingThreshold encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold,
        interceptor: RequestInterceptor? = nil,
        fileManager: FileManager = .default
    ) -> Observable<RequestContext<UploadRequest>> {
        getRequest { $0.upload(multipartFormData: multipartFormData, with: request, usingThreshold: encodingMemoryThreshold, interceptor: interceptor, fileManager: fileManager) }
        .map { RequestContext($0, $0.request) }
    }
    // MARK: Download
    public func download(_ urlRequest: URLRequestConvertible,
                         interceptor: RequestInterceptor? = nil,
                         to destination: DownloadRequest.Destination? = nil) -> Observable<RequestContext<DownloadRequest>> {
        getRequest { $0.download(urlRequest, interceptor: interceptor, to: destination) }
            .map { RequestContext($0, urlRequest) }
    }
    public func download(resumeData: Data,
                         interceptor: RequestInterceptor? = nil,
                         to destination: DownloadRequest.Destination? = nil) -> Observable<RequestContext<DownloadRequest>> {
        getRequest { $0.download(resumingWith: resumeData, interceptor: interceptor, to: destination) }
            .map { RequestContext($0, $0.request) }
    }
}
extension Session {
    func uploadParamsUpdate(_ formData: [MultipartFormData], _ urlRequest: URLRequestConvertible) -> ([MultipartFormData], URLRequestConvertible) {
        var formData = formData
        var urlRequest = urlRequest
        // ZJaDe: 如果参数里包含了MultipartFormData，需要添加
        if var target = urlRequest as? TargetType, var params = target.parameters {
            for (key, value) in params {
                if let value = value as? MultipartFormData {
                    params[key] = nil
                    formData.append(value)
                }
            }
            target.parameters = params
            urlRequest = target
        }
        return (formData, urlRequest)
    }
}
extension Reactive where Base: Session {
    private func getRequest<R: RxAlamofireRequest>(_ createRequest: @escaping (Session) throws -> R) -> Observable<R> {
        getRequest { (manager, observer) in
            let request = try createRequest(manager)
            return request.onNext(observer, manager)
        }
    }
    private func getRequest<R: RxAlamofireRequest>(_ closure: @escaping (Session, AnyObserver<R>) throws -> Disposable) -> Observable<R> {
        Observable.create { observer -> Disposable in
            do {
                return try closure(self.base, observer)
            } catch let error {
                observer.onError(error)
                return Disposables.create()
            }
        }
    }
}
extension RxAlamofireRequest {
    fileprivate func onNext(_ observer: AnyObserver<Self>, _ session: Session) -> Disposable {
        observer.onNext(self)
        responseWith(completionHandler: { (_) in
//            if let error = response.error {
//                observer.onError(error)
//            } else {
//                observer.onCompleted()
//            }
            /// ZJaDe: 请求完成后发送完成时间，保证序列释放，不能发送error事件，response()方法里面会处理
            observer.onCompleted()
        })

        if !session.startRequestsImmediately {
            self.resume()
        }

        return Disposables.create {
            self.cancel()
        }
    }
}
