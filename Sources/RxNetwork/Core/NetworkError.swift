//
//  NetworkError.swift
//  PaiBaoTang
//
//  Created by ZJaDe on 2017/7/14.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
public enum NetworkError: Swift.Error {
    case jsonMapping(Swift.Error)
    case objectMapping(String)
    case unknown(Swift.Error)
    case error(String)
    case ignore
    case statusCode(Int)
    case noNetwork
    case timeout
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .jsonMapping(let error):
            var keyValue: [(String, Any)] = []
            #if DEBUG || Beta || POD_CONFIGURATION_BETA
            if let error = error as? DecodingError {
                let context: DecodingError.Context?
                switch error {
                case .dataCorrupted(let _context):
                    keyValue.append(("error", "数据损坏"))
                    context = _context
                case .keyNotFound(let key, let _context):
                    keyValue.append(("error", "找不到对应的key"))
                    keyValue.append(("key", key))
                    context = _context
                case .typeMismatch(let type, let _context):
                    keyValue.append(("error", "类型不匹配"))
                    keyValue.append(("type", type))
                    context = _context
                case .valueNotFound(let type, let _context):
                    keyValue.append(("error", "没有找到value"))
                    keyValue.append(("type", type))
                    context = _context
                @unknown default:
                    context = nil
                }
                if let context = context {
                    keyValue.append(("codingPath", context.codingPath.map {$0.stringValue}.joined(separator: ", ")))
                    keyValue.append(("debugDescription", context.debugDescription))
                }
            } else {
                keyValue.append(("请求错误: ", error.localizedDescription))
            }
            return keyValue.map {"\($0): \($1)"}.joined(separator: ", \n")
            #else
            return "请求失败"
            #endif
        case .objectMapping(let errorStr):
            #if DEBUG || Beta || POD_CONFIGURATION_BETA
            return "对象转化失败: \(errorStr)"
            #else
            return "请求失败"
            #endif
        case .unknown(let error):
            #if DEBUG || Beta || POD_CONFIGURATION_BETA
            return "\(error.localizedDescription)"
            #else
            return "请求失败"
            #endif
        case .error(let errorStr):
            #if DEBUG || Beta || POD_CONFIGURATION_BETA
            return errorStr
            #else
            return "请求失败"
            #endif
        case .ignore:
            return ""
        case .statusCode(let statusCode):
            #if DEBUG || Beta || POD_CONFIGURATION_BETA
            return "状态码错误: \(statusCode))"
            #else
            return "网络错误，请稍后重试"
            #endif
        case .noNetwork:
            return "当前网络不可用"
        case .timeout:
            return "请求超时"
        }
    }
}
