//
//  RequestContext.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkContextCompatible {
    associatedtype ValueType
    var value: ValueType { get }
    func map<T>(_ transform: (ValueType) throws -> T) rethrows -> NetworkContext<T>
}

public typealias RequestContext<V> = NetworkContext<V> where V: RxAlamofireRequest
public typealias ResponseContext<V> = NetworkContext<Result<V>>
public typealias DataResponseContext = ResponseContext<Data>
public typealias ResultContext<M> = NetworkContext<M>

public protocol RequestContextCompatible: NetworkContextCompatible {}
extension RequestContext: RequestContextCompatible {}

public protocol ResponseContextCompatible: NetworkContextCompatible {}
extension ResponseContext: ResponseContextCompatible {}

public protocol ResultContextCompatible: NetworkContextCompatible {}
extension ResultContext: ResultContextCompatible {}
// MARK: -
/// 第一步是request、upload、download方法。返回RequestContext，Value是一个请求管理器
/// 第二步是response方法。返回ResponseContext，Value目前都是Result<Data>。可以省略
/// 第三部是各种map方法。返回ResultContext，Value是格式化好的Model
public struct NetworkContext<Value>: NetworkContextCompatible {
    public typealias ValueType = Value
    public let target: URLRequestConvertible?
    public let value: Value
    public init(_ value: Value, _ target: URLRequestConvertible?) {
        self.value = value
        self.target = target
    }
    public func map<T>(_ transform: (Value) throws -> T) rethrows -> NetworkContext<T> {
        NetworkContext<T>(try transform(value), self.target)
    }
}

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
