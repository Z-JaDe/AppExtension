//
//  SessionManager.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
public typealias RequestContextObservable<R> = Observable<RequestContext<R>>

extension SessionManager: ReactiveCompatible {}
extension Reactive where Base: SessionManager {
    public func request(_ method: HTTPMethod,
                        _ url: URLConvertible,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil) -> RequestContextObservable<DataRequest> {
        return request { $0.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers) }
            .map { RequestContext($0, $0.request) }
    }
    public func request(_ urlRequest: URLRequestConvertible) -> RequestContextObservable<DataRequest> {
        return request { $0.request(urlRequest) }
            .map { RequestContext($0, urlRequest) }
    }
    // MARK: Upload
    public func upload(_ file: URL, _ urlRequest: URLRequestConvertible) -> RequestContextObservable<UploadRequest> {
        return request { $0.upload(file, with: urlRequest) }
            .map { RequestContext($0, urlRequest) }
    }
    public func upload(_ data: Data, _ urlRequest: URLRequestConvertible) -> RequestContextObservable<UploadRequest> {
        return request { $0.upload(data, with: urlRequest) }
            .map { RequestContext($0, urlRequest) }
    }
    public func upload(_ stream: InputStream, _ urlRequest: URLRequestConvertible) -> RequestContextObservable<UploadRequest> {
        return request { $0.upload(stream, with: urlRequest) }
            .map { RequestContext($0, urlRequest) }
    }
    // MARK: Download
    public func download(_ urlRequest: URLRequestConvertible,
                         to destination: @escaping DownloadRequest.DownloadFileDestination) -> RequestContextObservable<DownloadRequest> {
        return request { $0.download(urlRequest, to: destination) }
            .map { RequestContext($0, urlRequest) }
    }
    public func download(resumeData: Data,
                         to destination: @escaping DownloadRequest.DownloadFileDestination) -> RequestContextObservable<DownloadRequest> {
        return request { $0.download(resumingWith: resumeData, to: destination) }
            .map { RequestContext($0, $0.request) }
    }
}
extension Reactive where Base: SessionManager {
    private func request<R: RxAlamofireRequest>(_ createRequest: @escaping (SessionManager) throws -> R) -> Observable<R> {
        return Observable.create { observer -> Disposable in
            do {
                let request = try createRequest(self.base)
                observer.on(.next(request))
                request.responseWith(completionHandler: { (response) in
                    if let error = response.error {
                        observer.on(.error(error))
                    } else {
                        observer.on(.completed)
                    }
                })

                if !self.base.startRequestsImmediately {
                    request.resume()
                }

                return Disposables.create {
                    request.cancel()
                }
            } catch let error {
                observer.on(.error(error))
                return Disposables.create()
            }
        }
    }
}
