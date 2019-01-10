//
//  RequestContext+Map.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

extension RequestContext where Value == Result<Data> {
    func getData() throws -> Data {
        switch self.value {
        case .success(let value):
            return value
        case .failure(let error):
            /// ZJaDe: Alamofire内部抛出的Error处理
            throw error._mapError()
        }
    }
    public func map<T: Decodable>() throws -> T {
        logDataResultInfo()
        let data = try getData()
        let result: T
        do {
            result = try T.deserialize(from: data)
        } catch let error {
            logError("-: \(self.urlPath) 接口解析失败")
            throw NetworkError.jsonMapping(error)
        }
        return result
    }

    public func mapCustomType<DataType: Decodable>() throws -> DataType {
        do {
            return try map()
        } catch _ {
            // ZJaDe: 自定义的类型如果失败直接返回response数据
            throw NetworkError.error((try? mapString()) ?? "转换出错")
        }
    }

    public func mapString() throws -> String {
        guard let string = String(data: try getData(), encoding: .utf8) else {
            throw NetworkError.objectMapping("转换字符串出错")
        }
        return string
    }

    private func logDataResultInfo() {
        switch self.value {
        case .failure(let error):
            logError("-|\(self.urlPath) 接口报错->\(error.localizedDescription)")
        case .success:
            let str = try? mapString()
            logInfo("获取到 -|\(self.urlPath) 接口数据->\(str ?? "空")")
        }
    }
}
// MARK: -
/// ZJaDe: data转换成ResultModel时
public protocol MapResultProtocol {
    func mapResult<T: AbstractResultModelType&Decodable>() throws -> T
}
extension RequestContext where Value == Result<Data> {
    internal func _mapResult<T: AbstractResultModelType&Decodable>() throws -> T {
        if let context = self as? MapResultProtocol {
            return try context.mapResult()
        } else {
            return try map()
        }
    }
}
