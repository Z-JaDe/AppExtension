//
//  Observable+JSON.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/9/20.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

let dataResponseSerializer = DataResponseSerializer()

extension ObservableType where Element: RequestContextCompatible, Element.R: DataRequest {
    public func responseMap<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<DataResponseContext<T>> {
        response(queue: .main, responseSerializer: KeyPathDecodableResponseSerializer<T>(atKeyPath: keyPath))
    }
    public func responseData(queue: DispatchQueue = .main) -> Observable<DataResponseContext<Data>> {
        response(queue: queue, responseSerializer: dataResponseSerializer)
    }
}
extension ObservableType where Element: RequestContextCompatible, Element.R: DownloadRequest {
    public func responseMap<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) -> Observable<DownloadResponseContext<T>> {
        response(queue: .main, responseSerializer: KeyPathDecodableResponseSerializer<T>(atKeyPath: keyPath))
    }
    public func responseData(queue: DispatchQueue = .main) -> Observable<DownloadResponseContext<Data>> {
        response(queue: queue, responseSerializer: dataResponseSerializer)
    }
}
