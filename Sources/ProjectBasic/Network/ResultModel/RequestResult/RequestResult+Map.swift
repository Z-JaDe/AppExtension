//
//  RequestContext+Map.swift
//  SNKit_TJS
//
//  Created by 郑军铎 on 2018/5/14.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
import Alamofire
protocol MapResultProtocol {
    func mapResult<T: ResultModelType&Decodable>() throws -> T
}
extension RequestContext where Value == Result<Data> {
    // MARK: - result
    public func mapResult<DataType: Decodable>() throws -> ResultModel<DataType> {
        return try _map()
    }
    public func mapStringResult() throws -> StringResultModel {
        return try _map()
    }
    public func mapObject<T: Decodable>(type: T.Type) throws -> ObjectResultModel<T> {
        return try _map()
    }
    public func mapArray<T: Decodable>(type: T.Type) throws -> ArrayResultModel<T> {
        return try _map()
    }
    public func mapList<T: Decodable>(type: T.Type) throws -> ObjectResultModel<ListResultModel<T>> {
        return try _map()
    }

    private func _map<T: ResultModelType&Decodable>() throws -> T {
        if let context = self as? MapResultProtocol {
            return try context.mapResult()
        } else {
            return try map()
        }
    }
}
