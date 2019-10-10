//
//  RxAlamofireResponse.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

public protocol RxAlamofireRequest {
    func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void)
    @discardableResult
    func resume() -> Self
    @discardableResult
    func cancel() -> Self
}

public protocol RxAlamofireResponse {}
public protocol AbstractRxAlamofireResponse: RxAlamofireResponse {
    associatedtype Success
}
extension AFDataResponse: AbstractRxAlamofireResponse {}
extension AFDownloadResponse: AbstractRxAlamofireResponse {}

extension DataRequest: RxAlamofireRequest {
    public func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
        response { (response) in
            completionHandler(response)
        }
    }
}

extension DownloadRequest: RxAlamofireRequest {
    public func responseWith(completionHandler: @escaping (RxAlamofireResponse) -> Void) {
        response { (response) in
            completionHandler(response)
        }
    }
}
