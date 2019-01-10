//
//  SessionManager.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import RxSwiftExt
import Alamofire
/** ZJaDe:
 订阅Request消息后，请求会开始发送，
 在response、progress或者map方法里面可以截取到获取的数据
 */
// MARK: -
/// ZJaDe: 类型约束
public protocol RequestableContext: RequestContextCompatible {}
extension RequestContext: RequestableContext where Value: RxAlamofireRequest {}
public typealias RequestContextObservable<R> = Observable<RequestContext<R>>

extension SessionManager: ReactiveCompatible {}
extension Reactive where Base: SessionManager {
    // MARK: Request
    public func request(_ method: HTTPMethod,
                        _ url: URLConvertible,
                        parameters: Parameters? = nil,
                        encoding: ParameterEncoding = URLEncoding.default,
                        headers: HTTPHeaders? = nil) -> RequestContextObservable<DataRequest> {
        return getRequest { $0.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers) }
            .map { RequestContext($0, $0.request) }
    }
    public func request(_ urlRequest: URLRequestConvertible) -> RequestContextObservable<DataRequest> {
        return getRequest { $0.request(urlRequest) }
            .map { RequestContext($0, urlRequest) }
    }
    // MARK: Upload
    public func upload(_ formData: [MultipartFormData], usingThreshold encodingMemoryThreshold: UInt64 = SessionManager.multipartFormDataEncodingMemoryThreshold, _ urlRequest: URLRequestConvertible) -> RequestContextObservable<UploadRequest> {
        return getRequest({ (manager, observer) -> Disposable in
            var dispose: Disposable?
            let (formData, urlRequest) = manager.uploadParamsUpdate(formData, urlRequest)
            manager.upload(multipartFormData: {$0.applyMultipartFormData(formData)}, usingThreshold: encodingMemoryThreshold, with: urlRequest, encodingCompletion: { (result) in
                switch result {
                case .failure(let error):
                    observer.onError(error)
                case .success(request: let request, streamingFromDisk: _, streamFileURL: _):
                    dispose = request.onNext(observer, manager)
                }
            })
            return Disposables.create {
                dispose?.dispose()
            }
        }).map { RequestContext($0, urlRequest) }
    }
    // MARK: Download
    public func download(_ urlRequest: URLRequestConvertible,
                         to destination: @escaping DownloadRequest.DownloadFileDestination) -> RequestContextObservable<DownloadRequest> {
        return getRequest { $0.download(urlRequest, to: destination) }
            .map { RequestContext($0, urlRequest) }
    }
    public func download(resumeData: Data,
                         to destination: @escaping DownloadRequest.DownloadFileDestination) -> RequestContextObservable<DownloadRequest> {
        return getRequest { $0.download(resumingWith: resumeData, to: destination) }
            .map { RequestContext($0, $0.request) }
    }
}
extension SessionManager {
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
extension Reactive where Base: SessionManager {
    private func getRequest<R: RxAlamofireRequest>(_ createRequest: @escaping (SessionManager) throws -> R) -> Observable<R> {
        return getRequest { (manager, observer) in
            let request = try createRequest(manager)
            return request.onNext(observer, manager)
        }
    }
    private func getRequest<R: RxAlamofireRequest>(_ closure: @escaping (SessionManager, AnyObserver<R>) throws -> Disposable) -> Observable<R>  {
        return Observable.create { observer -> Disposable in
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
    fileprivate func onNext(_ observer: AnyObserver<Self>, _ manager: SessionManager) -> Disposable {
        observer.onNext(self)

        if !manager.startRequestsImmediately {
            self.resume()
        }

        return Disposables.create {
            self.cancel()
        }
    }
}
