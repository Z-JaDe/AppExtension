//
//  Codable.swift
//  AppExtension
//
//  Created by 郑军铎 on 2018/7/12.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation
extension Encodable where Self: ValueProtocol, Self.ValueType: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.value)
    }
}
extension Decodable where Self: ExpressibleValueProtocol {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self.init(nilLiteral: ())
        } else if let value = try? container.decode(Int.self) {
            self.init(integerLiteral: value)
        } else if let value = try? container.decode(Double.self) {
            self.init(floatLiteral: value)
        } else if let value = try? container.decode(String.self) {
            self.init(stringLiteral: value)
        } else {
            self.init(nilLiteral: ())
        }
    }
}
