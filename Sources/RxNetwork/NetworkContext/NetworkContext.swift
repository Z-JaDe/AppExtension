//
//  NetworkContext.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkContextCompatible {}
public typealias DataResultContext = ResponseContext<Data>
// MARK: - 协议
public protocol RequestContextCompatible: NetworkContextCompatible {
    associatedtype Value: RxAlamofireRequest
    var value: Value { get }
    func mapResponse<T>(_ transform: (Value) throws -> AFDataResponse<T>) rethrows -> ResponseContext<T>
}
extension RequestContext: RequestContextCompatible {
    public func mapResponse<T>(_ transform: (Value) throws -> AFDataResponse<T>) rethrows -> ResponseContext<T> {
        ResponseContext<T>(try transform(value), self.target)
    }
}

public protocol ResponseContextCompatible: NetworkContextCompatible {
    associatedtype Value
    associatedtype Result
    var result: Result { get }
    func map<T>(_ transform: (Value) throws -> T) rethrows -> ResponseContext<T>
}
extension ResponseContext: ResponseContextCompatible {}

// MARK: - 具体实现
/// 第一步是request、upload、download方法。返回RequestContext，Value是一个请求管理器
/// 第二步是response方法。返回ResponseContext，Value目前都是Result<Data>。可以省略
/// 第三部是各种map方法。返回ResponseContext，Value是格式化好的Model
public struct ResponseContext<Value> {
    public typealias Result = Swift.Result<Value, NetworkError>
    public let target: URLRequestConvertible?
    public let result: Self.Result
    public init(_ result: Self.Result, _ target: URLRequestConvertible?) {
        self.result = result
        self.target = target
    }
    public init(_ response: AFDataResponse<Value>, _ target: URLRequestConvertible?) {
        self.result = response.result.mapError({NetworkError.unknown($0)})
        self.target = target
    }
    public func map<T>(_ transform: (Value) throws -> T) -> ResponseContext<T> {
        ResponseContext<T>(result.tryMap({try transform($0)}).mapError({NetworkError.unknown($0)}), self.target)
    }
}
public struct RequestContext<Value: RxAlamofireRequest> {
    public let target: URLRequestConvertible?
    public let value: Value
    public init(_ value: Value, _ target: URLRequestConvertible?) {
        self.value = value
        self.target = target
    }
    func map(_ transform: (Value) throws -> Value) rethrows -> Self {
        return .init(try transform(value), target)
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
extension Result {
    func tryMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Error> {
        switch self {
        case let .success(value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(error)
            }
        case let .failure(error):
            return .failure(error)
        }
    }
}
