//
//  RequestContext+Map.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2019/1/3.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation
import Alamofire

extension DataResultContext {
    func getData() throws -> Data {
        switch self.value {
        case .success(let value):
            return value
        case .failure(let error):
            /// ZJaDe: Alamofire内部抛出的Error处理
            throw error._mapError()
        }
    }
    ///不能直接使用 封装时可能会用到
    public func _map<T: Decodable>() throws -> T {
        logDataResultInfo()
        let data = try getData()
        do {
            return try T.deserialize(from: data)
        } catch let error {
            logError("-: \(self.urlPath) 接口解析失败")
            throw NetworkError.jsonMapping(error)
        }
    }
    ///不能直接使用 封装时可能会用到
    public func _map<T: Decodable>(atKeyPath keyPath: String) throws -> T {
        guard let jsonObject = (try JSONSerialization.jsonObject(with: getData(), options: .allowFragments) as? NSDictionary)?.value(forKeyPath: keyPath) else {
            throw NetworkError.objectMapping("没有\(keyPath)")
        }
        do {
            return try T.deserialize(from: jsonObject)
        } catch let error {
            throw NetworkError.jsonMapping(error)
        }
    }
}

extension DataResultContext {
    public func map<T: Decodable>(type: T.Type, atKeyPath keyPath: String? = nil) throws -> T {
        do {
            if let keyPath = keyPath, keyPath.isEmpty == false {
                return try _map(atKeyPath: keyPath)
            } else {
                return try _map()
            }
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
    public func mapImage() throws -> UIImage {
        guard let image = UIImage(data: try getData()) else {
            throw NetworkError.objectMapping("图片转换失败")
        }
        return image
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
    func mapResult<T: AbstractResultModelType & Decodable>() throws -> T
}
extension DataResultContext {
    public func _mapResult<T: AbstractResultModelType & Decodable>() throws -> T {
        if let context = self as? MapResultProtocol {
            return try context.mapResult()
        } else {
            return try _map()
        }
    }
}
