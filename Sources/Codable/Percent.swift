//
//  Percent.swift
//  SNKit
//
//  Created by ZJaDe on 2018/5/29.
//  Copyright © 2018年 syk. All rights reserved.
//

import Foundation
/** ZJaDe: 
 传进一个小于等于100的数，用来计算
 */
public struct Percent: FloatLiteralTypeValueProtocol,
    Comparable,
    Codable,
    ExpressibleValueProtocol,
    AddCalculatable,
    CustomStringConvertible, CustomDebugStringConvertible {

    public typealias ValueType = FloatLiteralType
    public private(set) var originString: String = ""
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        if let value = value, value > 0 {
            self.value = value
        } else {
            self.value = 0
        }
        self.originString = "\(valueFormat(nil))"
    }
    public init(stringLiteral value: String) {
        self.value = value.toDouble
        self.originString = value
    }
    // MARK: -
    public var positiveFormat = "#0.##"

    public let unit: String = "%"

    public var realValue: ValueType {
        self.value / 100
    }

    public var description: String {
        "\(self.originString)\(unit)"
    }
}
