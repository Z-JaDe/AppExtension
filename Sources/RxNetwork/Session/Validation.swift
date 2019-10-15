//
//  Validation.swift
//  AppExtension
//
//  Created by ZJaDe on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
extension ObservableType where Element: RequestContextCompatible, Element.R == DataRequest {
    public func validate<S: Sequence>(statusCode: S) -> Observable<Element> where S.Element == Int {
        map { $0.map {$0.validate(statusCode: statusCode)} }
    }

    public func validate() -> Observable<Element> {
        map { $0.map {$0.validate()} }
    }

    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<Element> where S.Iterator.Element == String {
        map { $0.map {$0.validate(contentType: acceptableContentTypes)} }
    }

    public func validate(_ validation: @escaping DataRequest.Validation) -> Observable<Element> {
        map { $0.map {$0.validate(validation)} }
    }
}
extension ObservableType where Element: RequestContextCompatible, Element.R == DownloadRequest {
    public func validate<S: Sequence>(statusCode: S) -> Observable<Element> where S.Element == Int {
        map { $0.map {$0.validate(statusCode: statusCode)} }
    }

    public func validate() -> Observable<Element> {
        map { $0.map {$0.validate()} }
    }

    public func validate<S: Sequence>(contentType acceptableContentTypes: S) -> Observable<Element> where S.Iterator.Element == String {
        map { $0.map {$0.validate(contentType: acceptableContentTypes)} }
    }

    public func validate(_ validation: @escaping DownloadRequest.Validation) -> Observable<Element> {
        map { $0.map {$0.validate(validation)} }
    }
}
