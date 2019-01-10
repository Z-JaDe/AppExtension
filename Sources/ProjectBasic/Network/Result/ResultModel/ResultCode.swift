//
//  ResultCode.swift
//  SNKitCore
//
//  Created by 郑军铎 on 2018/11/23.
//  Copyright © 2018 数牛. All rights reserved.
//

import Foundation

public struct ResultCode: RawRepresentable, Equatable, Codable, CustomStringConvertible {
    public var rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let error: ResultCode = ResultCode(rawValue: -1001)
    public static let successful: ResultCode = ResultCode(rawValue: 0)

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.rawValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = container.decodeInt() {
            self = ResultCode(rawValue: value)
        } else {
            self = .error
        }
    }
    public var description: String {
        return "错误码\(self.rawValue)"
    }
}
