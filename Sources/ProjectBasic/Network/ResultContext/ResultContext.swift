//
//  ResponseContext.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/11/22.
//  Copyright © 2018 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public typealias StringResponseResult = ResponseContext<StringResultModel>
public typealias DictResponseResult = ResponseContext<DictResultModel>
public typealias AnyResponseResult<T> = ResponseContext<ResultModel<T>> where T: Codable

public typealias ObjectResponseResult<T> = ResponseContext<ObjectResultModel<T>> where T: Codable
public typealias ArrayResponseResult<T> = ResponseContext<ArrayResultModel<T>> where T: Codable

public typealias ListRequesxtResult<T> = ObjectResponseResult<ListResultModel<T>> where T: Codable
// MARK: -
extension ObservableType where Element: NetworkContextCompatible {
    public typealias StringResult = ResponseContext<StringResultModel>
    public typealias DictResult = ResponseContext<DictResultModel>
    public typealias AnyResult<T> = ResponseContext<ResultModel<T>> where T: Codable

    public typealias ObjectResult<T> = ResponseContext<ObjectResultModel<T>> where T: Codable
    public typealias ArrayResult<T> = ResponseContext<ArrayResultModel<T>> where T: Codable

    public typealias ListResult<T> = ObjectResult<ListResultModel<T>> where T: Codable
}
