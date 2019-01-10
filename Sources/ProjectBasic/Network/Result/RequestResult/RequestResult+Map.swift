//
//  RequestContext+Map.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/14.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import Alamofire

extension RequestContext where Value == Result<Data> {
    public func mapResult<DataType: Decodable>() throws -> ResultModel<DataType> {
        return try _mapResult()
    }
    public func mapStringResult() throws -> StringResultModel {
        return try _mapResult()
    }
    public func mapObject<T: Decodable>(type: T.Type) throws -> ObjectResultModel<T> {
        return try _mapResult()
    }
    public func mapArray<T: Decodable>(type: T.Type) throws -> ArrayResultModel<T> {
        return try _mapResult()
    }
    public func mapList<T: Decodable>(type: T.Type) throws -> ObjectResultModel<ListResultModel<T>> {
        return try _mapResult()
    }
}

