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
extension ObservableType where Element: RequestContextCompatible, Element.R: DataRequest {
    public func mapDictResult() -> Observable<DataResponseContext<DictResultModel>> {
        responseMap(type: DictResultModel.self)
    }
    public func mapResult<T: Decodable>(type: T.Type) -> Observable<DataResponseContext<ResultModel<T>>> {
        responseMap(type: ResultModel<T>.self)
    }
    public func mapStringResult() -> Observable<DataResponseContext<StringResultModel>> {
        responseMap(type: StringResultModel.self)
    }
    public func mapObject<T: Decodable>(type: T.Type) -> Observable<DataResponseContext<ObjectResultModel<T>>> {
        responseMap(type: ObjectResultModel<T>.self)
    }
    public func mapArray<T: Decodable>(type: T.Type) -> Observable<DataResponseContext<ArrayResultModel<T>>> {
        responseMap(type: ArrayResultModel<T>.self)
    }
    public func mapList<T: Decodable>(type: T.Type) -> Observable<DataResponseContext<ObjectResultModel<ListResultModel<T>>>> {
        mapObject(type: ListResultModel<T>.self)
    }
}
