//
//  Validation.swift
//  AppExtension
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
extension ObservableType where E == RequestContext<DataRequest> {
    public func validate<S: Sequence>(statusCode: S) -> Observable<E> where S.Element == Int {
        return map { $0.map {$0.validate(statusCode: statusCode)} }
    }

    public func validate() -> Observable<E> {
        return map { $0.map {$0.validate()} }
    }

    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<E> where S.Iterator.Element == String {
        return map { $0.map {$0.validate(contentType: acceptableContentTypes)} }
    }

    public func validate(_ validation: @escaping DataRequest.Validation) -> Observable<E> {
        return map { $0.map {$0.validate(validation)} }
    }
}

extension ObservableType where E == RequestContext<DownloadRequest> {
    public func validate<S: Sequence>(statusCode: S) -> Observable<E> where S.Element == Int {
        return map { $0.map {$0.validate(statusCode: statusCode)} }
    }

    public func validate() -> Observable<E> {
        return map { $0.map {$0.validate()} }
    }

    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<E> where S.Iterator.Element == String {
        return map { $0.map {$0.validate(contentType: acceptableContentTypes)} }
    }

    public func validate(_ validation: @escaping DownloadRequest.Validation) -> Observable<E> {
        return map { $0.map {$0.validate(validation)} }
    }
}
