//
//  RequestContext.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
public protocol RequestContextCompatible {
    associatedtype ValueType
    var value: ValueType { get }
    func map<T>(_ transform: (ValueType) throws -> T) rethrows -> RequestContext<T>
}

public struct RequestContext<Value>: RequestContextCompatible {
    public typealias ValueType = Value
    public let target: URLRequestConvertible?
    public let value: Value
    public init(_ value: Value, _ target: URLRequestConvertible?) {
        self.value = value
        self.target = target
    }
    public func map<T>(_ transform: (Value) throws -> T) rethrows -> RequestContext<T> {
        return RequestContext<T>(try transform(value), self.target)
    }
}
extension RequestContext {
    /// ZJaDe: 接口path
    public var urlPath: String {
        guard let url = target as? TargetType else {
            return (try? target?.asURLRequest())??.url?.absoluteString ?? "未知"
        }
        guard url.path.isNotEmpty else {
            return url.baseURL.absoluteString
        }
        return url.path
    }
}
