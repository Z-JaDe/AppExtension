//
//  Response.swift
//  RxNetwork
//
//  Created by Apple on 2019/10/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol Response {
    associatedtype Value
    associatedtype Failure: Error
    typealias Result = Swift.Result<Value, Failure>
    var result: Result {get}
}
extension AFDataResponse: Response {}
extension AFDownloadResponse: Response {}

extension Result where Failure == NetworkError {
    func tryMap<NewSuccess>(_ transform: (Success) throws -> NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
        case let .success(value):
            do {
                return try .success(transform(value))
            } catch {
                return .failure(NetworkError.unknown(error))
            }
        case let .failure(error):
            return .failure(error)
        }
    }
}
