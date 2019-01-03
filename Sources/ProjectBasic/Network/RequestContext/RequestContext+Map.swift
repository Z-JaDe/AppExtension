//
//  RequestContext+Map.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension RequestContext where Value == Data {
    public func map<T: Decodable>() throws -> T {
        logDataResultInfo()
        let data = value
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
        guard let string = String(data: value, encoding: .utf8) else {
            throw NetworkError.objectMapping("转换字符串出错")
        }
        return string
    }

    private func logDataResultInfo() {
        let str = try? mapString()
        logInfo("获取到 -|\(self.urlPath) 接口数据->\(str ?? "空")")
    }
}
// TODO: Data换成Result<Data>
// TODO: 打印 logError("-|\(self.urlPath) 接口报错->\(error.localizedDescription)")
