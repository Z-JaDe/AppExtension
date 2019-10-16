//
//  Session.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/3.
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
    }
    public func request(_ urlRequest: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> Observable<RequestContext<DataRequest>> {
        getRequest { $0.request(urlRequest, interceptor: interceptor) }
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
    }
    public func upload(
        multipartFormData: MultipartFormData,
        with request: URLRequestConvertible,
        usingThreshold encodingMemoryThreshold: UInt64 = MultipartFormData.encodingMemoryThreshold,
        interceptor: RequestInterceptor? = nil,
        fileManager: FileManager = .default
    ) -> Observable<RequestContext<UploadRequest>> {
        getRequest { $0.upload(multipartFormData: multipartFormData, with: request, usingThreshold: encodingMemoryThreshold, interceptor: interceptor, fileManager: fileManager) }
    }
    // MARK: Download
    public func download(_ urlRequest: URLRequestConvertible,
                         interceptor: RequestInterceptor? = nil,
                         to destination: DownloadRequest.Destination? = nil) -> Observable<RequestContext<DownloadRequest>> {
        getRequest { $0.download(urlRequest, interceptor: interceptor, to: destination) }
    }
    public func download(resumeData: Data,
                         interceptor: RequestInterceptor? = nil,
                         to destination: DownloadRequest.Destination? = nil) -> Observable<RequestContext<DownloadRequest>> {
        getRequest { $0.download(resumingWith: resumeData, interceptor: interceptor, to: destination) }
    }
}
extension Reactive where Base: Session {
    private func getRequest<R: Request>(_ createRequest: @escaping (Session) -> R) -> Observable<RequestContext<R>> {
        getRequest(createRequest).map { RequestContext($0) }
    }
    /**
     订阅时发送一个信号 启动数据流
     后面接收到数据后自己根据情况控制信号结束
     不在这里控制信号的结束是因为有些接口可能会重新请求，重新请求使用的是Alamofire的逻辑
     */
    private func getRequest<R: Request>(_ createRequest: @escaping (Session) -> R) -> Observable<R> {
        Observable<R>.create { observer -> Disposable in
            let session = self.base
            let request = createRequest(session)
            observer.onNext(request)
            if !session.startRequestsImmediately {
                request.resume()
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
