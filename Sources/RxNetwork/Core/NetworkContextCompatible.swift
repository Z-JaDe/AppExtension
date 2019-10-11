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
    func map(_ transform: (R) throws -> R) rethrows -> Self
    func mapResponse<T>(_ transform: (R) -> AFDownloadResponse<T>) -> DownloadResponseContext<T>
    func mapResponse<T>(_ transform: (R) -> AFDataResponse<T>) -> DataResponseContext<T>
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
