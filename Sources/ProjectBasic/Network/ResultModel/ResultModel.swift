//
//  ResultModel.swift
//  ZiWoYou
//
//  Created by 茶古电子商务 on 16/12/19.
//  Copyright © 2016年 Z_JaDe. All rights reserved.
//

import Foundation
public protocol ResultModelType: AbstractResultModelType, InitProtocol {
    var resultCode: ResultCode? {get set}
    var message: String? {get set}
}
extension ResultModelType {
    public var isSuccessful: Bool {
        switch resultCode ?? .error {
        case .successful:
            return true
        default:
            return false
        }
    }
}
public class ResultModel<DataType: Codable>: Codable, ResultModelType {
    public var resultCode: ResultCode?
    public var message: String?
    public var data: DataType?
    public required init() {

    }
    public struct CodingKeys: CodingKey {
        public let stringValue: String
        public let intValue: Int?
        public init?(stringValue: String) {
            self.stringValue = stringValue
            self.intValue = Int(stringValue)
        }
        public init?(intValue: Int) {
            self.stringValue = "\(intValue)"
            self.intValue = intValue
        }
    }
    open var resultCodeKey: CodingKeys {
        return CodingKeys(stringValue: "e")!
    }
    open var messageKey: CodingKeys {
        return CodingKeys(stringValue: "msg")!
    }
    open var dataKey: CodingKeys {
        return CodingKeys(stringValue: "data")!
    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if (try? container.decodeNil(forKey: self.resultCodeKey)) == false {
            resultCode = try container.decode(ResultCode.self, forKey: self.resultCodeKey)
        } else {
            resultCode = .error
        }
        if (try? container.decodeNil(forKey: self.messageKey)) == false {
            message = try container.decode(String.self, forKey: self.messageKey)
        }
        if (try? container.decodeNil(forKey: self.dataKey)) == false {
            do {
                data = try container.decode(DataType.self, forKey: self.dataKey)
            } catch let error {
                #if DEBUG
                throw error
                #else
                data = nil
                #endif
            }
        }
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resultCode, forKey: self.resultCodeKey)
        try container.encode(message, forKey: self.messageKey)
        try container.encode(data, forKey: self.dataKey)
    }
}

public typealias DictResultModel = ResultModel<[String: String]>
public typealias StringResultModel = ResultModel<String>
public typealias ObjectResultModel<Model: Codable> = ResultModel<Model>
public typealias ArrayResultModel<Model: Codable> = ResultModel<[Model]>
