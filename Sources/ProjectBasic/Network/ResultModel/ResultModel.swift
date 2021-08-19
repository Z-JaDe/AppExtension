//
//  ResultModel.swift
//  ZiWoYou
//
//  Created by ZJaDe on 16/12/19.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
public protocol ResultModelType {
    var resultCode: ResultCode {get}
    var message: String {get}
    init(_ resultCode: ResultCode, _ message: String)
    func map(resultCode: ResultCode) -> Self
}
extension ResultModelType {
    public var isSuccessful: Bool {
        switch resultCode {
        case .successful:
            return true
        default:
            return false
        }
    }
}
public struct ResultModelCodingKeys: CodingKey {
    public let stringValue: String
    public let intValue: Int?
    public init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = Int(stringValue)
    }
    public init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    public static var resultCodeKey: ResultModelCodingKeys = ResultModelCodingKeys(stringValue: "e")
    public static var messageKey: ResultModelCodingKeys = ResultModelCodingKeys(stringValue: "msg")
    public static var dataKey: ResultModelCodingKeys = ResultModelCodingKeys(stringValue: "data")
}
public struct ResultModel<DataType: Decodable>: Decodable, ResultModelType {
    public let resultCode: ResultCode
    public let message: String
    public let data: DataType?
    public init(_ resultCode: ResultCode, _ message: String) {
        self.init(resultCode, message, nil)
    }
    public init(_ resultCode: ResultCode, _ message: String, _ data: DataType?) {
        self.resultCode = resultCode
        self.message = message
        self.data = data
    }
    public func map(resultCode: ResultCode) -> ResultModel<DataType> {
        return ResultModel(resultCode, message, data)
    }
    typealias CodingKeys = ResultModelCodingKeys
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if (try? container.decodeNil(forKey: CodingKeys.resultCodeKey)) == false {
            resultCode = try container.decode(ResultCode.self, forKey: CodingKeys.resultCodeKey)
        } else {
            resultCode = .error
        }
        if (try? container.decodeNil(forKey: CodingKeys.messageKey)) == false {
            message = try container.decode(String.self, forKey: CodingKeys.messageKey)
        } else {
            message = ""
        }
        if (try? container.decodeNil(forKey: CodingKeys.dataKey)) == false {
            do {
                data = try container.decode(DataType.self, forKey: CodingKeys.dataKey)
            } catch let error {
                #if DEBUG
                throw error
                #else
                data = nil
                #endif
            }
        } else {
            data = nil
        }
    }
}
extension ResultModel: Encodable where DataType: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resultCode, forKey: CodingKeys.resultCodeKey)
        try container.encode(message, forKey: CodingKeys.messageKey)
        try container.encode(data, forKey: CodingKeys.dataKey)
    }
}

public typealias DictResultModel = ResultModel<[String: String]>
public typealias StringResultModel = ResultModel<String>
public typealias ObjectResultModel<Model: Codable> = ResultModel<Model>
public typealias ArrayResultModel<Model: Codable> = ResultModel<[Model]>
