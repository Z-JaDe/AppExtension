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

public typealias StringDataResponseResult = DataResponseContext<StringResultModel>
public typealias DictDataResponseResult = DataResponseContext<DictResultModel>
public typealias AnyDataResponseResult<T> = DataResponseContext<ResultModel<T>> where T: Codable

public typealias ObjectDataResponseResult<T> = DataResponseContext<ObjectResultModel<T>> where T: Codable
public typealias ArrayDataResponseResult<T> = DataResponseContext<ArrayResultModel<T>> where T: Codable

public typealias ListDataResponseResult<T> = ObjectDataResponseResult<ListResultModel<T>> where T: Codable

