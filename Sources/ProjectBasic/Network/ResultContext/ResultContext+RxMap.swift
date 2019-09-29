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
extension ObservableType where Element == DataResultContext {
    public func mapDictResult() -> Observable<DictResult> {
        mapResult(type: [String: String].self)
    }
    public func mapResult<DataType: Decodable>(type: DataType.Type) -> Observable<AnyResult<DataType>> {
        mapResultModel {try $0.mapResult()}
    }
    public func mapStringResult() -> Observable<StringResult> {
        mapResultModel {try $0.mapStringResult()}
    }
    public func mapObject<T: Decodable>(type: T.Type) -> Observable<ObjectResult<T>> {
        mapResultModel {try $0.mapObject(type: type)}
    }
    public func mapArray<T: Decodable>(type: T.Type) -> Observable<ArrayResult<T>> {
        mapResultModel {try $0.mapArray(type: type)}
    }
    public func mapList<T: Decodable>(type: T.Type) -> Observable<ListResult<T>> {
        mapResultModel {try $0.mapList(type: type)}
    }
}
extension ObservableType where Element: RequestContextCompatible {
    public func mapDictResult() -> Observable<DictResult> {
        response().mapDictResult()
    }
    public func mapResult<DataType: Decodable>(type: DataType.Type) -> Observable<AnyResult<DataType>> {
        response().mapResult(type: type)
    }
    public func mapStringResult() -> Observable<StringResult> {
        response().mapStringResult()
    }
    public func mapObject<T: Decodable>(type: T.Type) -> Observable<ObjectResult<T>> {
        response().mapObject(type: type)
    }
    public func mapArray<T: Decodable>(type: T.Type) -> Observable<ArrayResult<T>> {
        response().mapArray(type: type)
    }
    public func mapList<T: Decodable>(type: T.Type) -> Observable<ListResult<T>> {
        response().mapList(type: type)
    }
}
