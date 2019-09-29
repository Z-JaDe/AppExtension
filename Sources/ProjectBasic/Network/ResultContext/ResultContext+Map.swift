//
//  RequestContext+Map.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/14.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import Alamofire

extension DataResultContext {
    public func mapResult<DataType: Decodable>() throws -> ResultModel<DataType> {
        try _mapResult()
    }
    public func mapStringResult() throws -> StringResultModel {
        try _mapResult()
    }
    public func mapObject<T: Decodable>(type: T.Type) throws -> ObjectResultModel<T> {
        try _mapResult()
    }
    public func mapArray<T: Decodable>(type: T.Type) throws -> ArrayResultModel<T> {
        try _mapResult()
    }
    public func mapList<T: Decodable>(type: T.Type) throws -> ObjectResultModel<ListResultModel<T>> {
        try _mapResult()
    }
}
