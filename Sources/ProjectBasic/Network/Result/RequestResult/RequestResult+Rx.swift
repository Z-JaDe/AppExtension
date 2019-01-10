//
//  Observable+JSON.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/9/20.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
extension ObservableType where E == RequestContext<Result<Data>> {
    public func mapDictResult() -> Observable<DictResult> {
        return mapResult(type: [String: String].self)
    }
    public func mapResult<DataType: Decodable>(type: DataType.Type) -> Observable<AnyResult<DataType>> {
        return mapResultModel {try $0.mapResult()}
    }
    public func mapStringResult() -> Observable<StringResult> {
        return mapResultModel {try $0.mapStringResult()}
    }
    public func mapObject<T: Decodable>(type: T.Type) -> Observable<ObjectResult<T>> {
        return mapResultModel {try $0.mapObject(type: type)}
    }
    public func mapArray<T: Decodable>(type: T.Type) -> Observable<ArrayResult<T>> {
        return mapResultModel {try $0.mapArray(type: type)}
    }
    public func mapList<T: Decodable>(type: T.Type) -> Observable<ListResult<T>> {
        return mapResultModel {try $0.mapList(type: type)}
    }
}
extension ObservableType where E: RequestableContext {
    public func mapDictResult() -> Observable<DictResult> {
        return response().mapDictResult()
    }
    public func mapResult<DataType: Decodable>(type: DataType.Type) -> Observable<AnyResult<DataType>> {
        return response().mapResult(type: type)
    }
    public func mapStringResult() -> Observable<StringResult> {
        return response().mapStringResult()
    }
    public func mapObject<T: Decodable>(type: T.Type) -> Observable<ObjectResult<T>> {
        return response().mapObject(type: type)
    }
    public func mapArray<T: Decodable>(type: T.Type) -> Observable<ArrayResult<T>> {
        return response().mapArray(type: type)
    }
    public func mapList<T: Decodable>(type: T.Type) -> Observable<ListResult<T>> {
        return response().mapList(type: type)
    }
}


