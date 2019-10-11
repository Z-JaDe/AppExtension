//
//  NetworkContext.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
// MARK: -
/// 第一步是request、upload、download方法。返回RequestContext，R是一个请求管理器
/// 第二步是response或者map方法。返回ResponseContext，R是Response。

public struct RequestContext<R: Request>: RequestContextCompatible {
    public let target: URLRequestConvertible?
    public let request: R
    public init(_ value: R, _ target: URLRequestConvertible?) {
        self.request = value
        self.target = target
    }
    public func map(_ transform: (R) throws -> R) rethrows -> Self {
        return .init(try transform(request), target)
    }
}
extension RequestContext {
    public func mapResponse<T>(_ transform: (R) -> AFDataResponse<T>) -> DataResponseContext<T> {
        ResponseContext(transform(request), self.target)
    }
    public func mapResponse<T>(_ transform: (R) -> AFDownloadResponse<T>) -> DownloadResponseContext<T> {
        ResponseContext(transform(request), self.target)
    }
}
public struct ResponseContext<R: Response>: ResponseContextCompatible {
    public let target: URLRequestConvertible?
    public let response: R
    public init(_ response: R, _ target: URLRequestConvertible?) {
        self.response = response
        self.target = target
    }
    public func map<T>(_ transform: (R) -> T) -> ResponseContext<T> {
        ResponseContext<T>(transform(response), self.target)
    }
}
// MARK: - 扩展
extension ResponseContext {
    /// ZJaDe: 接口path
    public var urlPath: String {
        guard let url = target as? TargetType else {
            return (try? target?.asURLRequest())??.url?.absoluteString ?? "未知"
        }
        guard url.path.isEmpty == false else {
            return url.baseURL.absoluteString
        }
        return url.path
    }
}

