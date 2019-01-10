//
//  RequestResult.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/22.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public typealias RequestResult<T> = RequestContext<T> where T: Codable
// ZJaDe:
public typealias StringRequestResult = RequestResult<StringResultModel>
public typealias DictRequestResult = RequestResult<DictResultModel>
public typealias AnyRequestResult<T> = RequestResult<ResultModel<T>> where T: Codable

public typealias ObjectRequestResult<T> = RequestResult<ObjectResultModel<T>> where T: Codable
public typealias ArrayRequestResult<T> = RequestResult<ArrayResultModel<T>> where T: Codable

public typealias ListRequesxtResult<T> = ObjectRequestResult<ListResultModel<T>> where T: Codable
// MARK: -
extension ObservableType where E: RequestContextCompatible {
    public typealias BaseResult<T> = RequestContext<T>
    public typealias StringResult = BaseResult<StringResultModel>
    public typealias DictResult = BaseResult<DictResultModel>
    public typealias AnyResult<T> = BaseResult<ResultModel<T>> where T: Codable

    public typealias ObjectResult<T> = BaseResult<ObjectResultModel<T>> where T: Codable
    public typealias ArrayResult<T> = BaseResult<ArrayResultModel<T>> where T: Codable

    public typealias ListResult<T> = ObjectResult<ListResultModel<T>> where T: Codable
}
