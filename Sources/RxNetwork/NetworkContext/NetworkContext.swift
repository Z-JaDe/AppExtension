//
//  NetworkContext.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkContextCompatible {
    associatedtype Value
    var value: Value { get }
}

public typealias DataResultContext = ResponseContext<Data>
// MARK: - 协议
public protocol RequestContextCompatible: NetworkContextCompatible where Value: RxAlamofireRequest {
    func map<T>(_ transform: (Value) throws -> Result<T>) rethrows -> ResponseContext<T>
}
extension RequestContext: RequestContextCompatible {
    public func map<T>(_ transform: (Value) throws -> Result<T>) rethrows -> ResponseContext<T> {
        ResponseContext<T>(try transform(value), self.target)
    }
}

public protocol ResponseContextCompatible: NetworkContextCompatible where Value == Result<ResultValue> {
    associatedtype ResultValue
    func map<T>(_ transform: (ResultValue) throws -> T) rethrows -> ResponseContext<T>
}
extension ResponseContext: ResponseContextCompatible {}

// MARK: - 具体实现
/// 第一步是request、upload、download方法。返回RequestContext，Value是一个请求管理器
/// 第二步是response方法。返回ResponseContext，Value目前都是Result<Data>。可以省略
/// 第三部是各种map方法。返回ResponseContext，Value是格式化好的Model
public struct ResponseContext<ResultValue> {
    public let target: URLRequestConvertible?
    public let value: Result<ResultValue>
    public init(_ value: Result<ResultValue>, _ target: URLRequestConvertible?) {
        self.value = value
        self.target = target
    }
    public func map<T>(_ transform: (ResultValue) throws -> T) -> ResponseContext<T> {
        ResponseContext<T>(value.flatMap({try transform($0)}), self.target)
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
