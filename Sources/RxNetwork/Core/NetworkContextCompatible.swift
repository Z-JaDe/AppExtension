//
//  NetworkContextCompatible.swift
//  RxNetwork
//
//  Created by Apple on 2019/10/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol NetworkContextCompatible {}

public typealias DataResponseContext<V> = ResponseContext<AFDataResponse<V>>
public typealias DownloadResponseContext<V> = ResponseContext<AFDownloadResponse<V>>

public protocol RequestContextCompatible: NetworkContextCompatible {
    associatedtype R: Request
    var request: R { get }
    func map(_ transform: (R) -> R) -> Self
}
extension RequestContextCompatible {
    public var target: URLRequestConvertible? {
        switch request {
        case let request as UploadRequest:
            return request.convertible
        case let request as DataRequest:
            return request.convertible
        case let request as DownloadRequest:
            if case .request(let target) = request.downloadable {
                return target
            }
            return nil
        default:
            return nil
        }
    }
}
extension RequestContextCompatible where R: DataRequest {
    public func mapResponse<T>(_ transform: (R) -> AFDataResponse<T>) -> DataResponseContext<T> {
        ResponseContext(transform(request), self.target)
    }
}
extension RequestContextCompatible where R: DownloadRequest {
    public func mapResponse<T>(_ transform: (R) -> AFDownloadResponse<T>) -> DownloadResponseContext<T> {
        ResponseContext(transform(request), self.target)
    }
}

public protocol ResponseContextCompatible: NetworkContextCompatible {
    associatedtype R: Response
    typealias Result = R.Result
    typealias Value = R.Value
    var response: R { get }
    func map<T>(_ transform: (R) -> T) -> ResponseContext<T>
}
extension ResponseContextCompatible {
    public var result: Result {
        return response.result
    }
}
