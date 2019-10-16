//
//  Codable.swift
//  Extension
//
//  Created by ZJaDe on 2017/10/18.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation

extension Decodable {
    public static func deserialize(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }
    public static func deserialize(from params: Any) throws -> Self {
        let data: Data
        if let string = params as? String {
            data = string.data(using: .utf8) ?? Data()
        } else {
            data = try JSONSerialization.data(withJSONObject: params, options: [])
        }
        return try deserialize(from: data)
    }
}
extension Encodable {
    public func serialize() throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(self)
    }
    public func toJSONObject() -> [String: Any]? {
        var _data: Data?
        if _data == nil, let string = self as? String {
            _data = string.data(using: .utf8)
        }
        if _data == nil {
            _data = try? serialize()
        }
        guard let data = _data else {
            return nil
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) else {
            return nil
        }
        return jsonObject as? [String: Any]
    }
}

//extension KeyedDecodingContainer {
//    public func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer.Key) throws -> Bool {
//        return try decodeIfPresent(type, forKey: key) ?? false
//    }
//    public func decodeIfPresent(_ type: Bool.Type, forKey key: KeyedDecodingContainer.Key) throws -> Bool? {
//        let container = try superDecoder(forKey: key).singleValueContainer()
//        if let value = try? container.decode(type) {
//            return value
//        }
//        if let value = try? container.decode(Int.self) {
//            return value != 0
//        }
//        if let value = try? container.decode(Double.self) {
//            return value != 0
//        }
//        if let value = try? container.decode(String.self) {
//            return value.toBool ?? false
//        }
//        return try container.decode(type)
//    }
//
//    public func decode(_ type: Int.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int {
//        return try decodeIfPresent(type, forKey: key) ?? 0
//    }
//    public func decodeIfPresent(_ type: Int.Type, forKey key: KeyedDecodingContainer.Key) throws -> Int? {
//        let container = try superDecoder(forKey: key).singleValueContainer()
//        if let value = try? container.decode(type) {
//            return value
//        }
//        if let value = try? container.decode(Bool.self) {
//            return value ? 1 : 0
//        }
//        if let value = try? container.decode(Double.self) {
//            return value.toInt
//        }
//        if let value = try? container.decode(String.self) {
//            return value.toInt
//        }
//        return try container.decode(type)
//    }
//
//    public func decode(_ type: Double.Type, forKey key: KeyedDecodingContainer.Key) throws -> Double {
//        return try decodeIfPresent(type, forKey: key) ?? 0
//    }
//    public func decodeIfPresent(_ type: Double.Type, forKey key: KeyedDecodingContainer.Key) throws -> Double? {
//        let container = try superDecoder(forKey: key).singleValueContainer()
//        if let value = try? container.decode(type) {
//            return value
//        }
//        if let value = try? container.decode(Bool.self) {
//            return value ? 1 : 0
//        }
//        if let value = try? decode(String.self, forKey: key) {
//            return value.toDouble
//        }
//        return try container.decode(type)
//    }
//
//    public func decode(_ type: Float.Type, forKey key: KeyedDecodingContainer.Key) throws -> Float {
//        return try decodeIfPresent(type, forKey: key) ?? 0
//    }
//    public func decodeIfPresent(_ type: Float.Type, forKey key: KeyedDecodingContainer.Key) throws -> Float? {
//        let container = try superDecoder(forKey: key).singleValueContainer()
//        if let value = try? container.decode(type) {
//            return value
//        }
//        if let value = try? container.decode(Bool.self) {
//            return value ? 1 : 0
//        }
//        if let value = try? decode(String.self, forKey: key) {
//            return value.toFloat
//        }
//        return try container.decode(type)
//    }
//
//    public func decode(_ type: String.Type, forKey key: KeyedDecodingContainer.Key) throws -> String {
//        return try decodeIfPresent(type, forKey: key) ?? ""
//    }
//    public func decodeIfPresent(_ type: String.Type, forKey key: KeyedDecodingContainer.Key) throws -> String? {
//        let container = try superDecoder(forKey: key).singleValueContainer()
//        if let value = try? container.decode(type) {
//            return value
//        }
//        if let value = try? container.decode(Bool.self) {
//            return value ? "1" : "0"
//        }
//        if let value = try? container.decode(Int.self) {
//            return "\(value)"
//        }
//        if let value = try? container.decode(Double.self) {
//            return "\(value)"
//        }
//        return try container.decode(type)
//    }
//}
//
