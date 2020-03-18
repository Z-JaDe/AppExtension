//
//  Observable+JSON.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/9/20.
//  Copyright © 2016 Z_JaDe. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxNetwork
extension ObservableType where Element: DataRequest {
    public func mapDictResult() -> Observable<RNDataResponse<DictResultModel>> {
        responseMap(type: DictResultModel.self)
    }
    public func mapResult<T: Decodable>(type: T.Type) -> Observable<RNDataResponse<ResultModel<T>>> {
        responseMap(type: ResultModel<T>.self)
    }
    public func mapStringResult() -> Observable<RNDataResponse<StringResultModel>> {
        responseMap(type: StringResultModel.self)
    }
    public func mapObject<T: Decodable>(type: T.Type) -> Observable<RNDataResponse<ObjectResultModel<T>>> {
        responseMap(type: ObjectResultModel<T>.self)
    }
    public func mapArray<T: Decodable>(type: T.Type) -> Observable<RNDataResponse<ArrayResultModel<T>>> {
        responseMap(type: ArrayResultModel<T>.self)
    }
    public func mapList<T: Decodable>(type: T.Type) -> Observable<RNDataResponse<ObjectResultModel<ListResultModel<T>>>> {
        mapObject(type: ListResultModel<T>.self)
    }
}
