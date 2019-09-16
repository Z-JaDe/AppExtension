//
//  Rate.swift
//  Codable
//
//  Created by 郑军铎 on 2018/6/13.
//  Copyright © 2018年 ZJaDe. All rights reserved.
//

import Foundation

/** ZJaDe: 
 传进一个小于等于100的小数，默认输出保留2位小数带%的字符串，可通过valueFormat，originString自定义输出
 Rate可以加减 但是Rate本身不能小于0，所以值小的Rate 减去 值大的Rate会等于 0
 */
public struct Rate: FloatLiteralTypeValueProtocol,
    Codable,
    Comparable,
    ExpressibleValueProtocol,
    Calculatable,
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
        self.originString = valueFormat(2)
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
    /// 返回rate字符串值

    public var description: String {
        "\(self.originString)\(unit)"
    }
}
/** ZJaDe: 
 传进一个小于等于1000的小数，默认输出保留2位小数带‰的字符串，可通过valueFormat，originString自定义输出
 */
public struct ThousandRate: FloatLiteralTypeValueProtocol,
    Codable,
    Comparable,
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
        self.originString = valueFormat(2)
    }
    public init(stringLiteral value: String) {
        self.value = value.toDouble
        self.originString = value
    }
    // MARK: -
    public var positiveFormat = "#0.##"

    public let unit: String = "‰"

    public var realValue: ValueType {
        self.value / 1000
    }
    /// 返回rate字符串值

    public var description: String {
        "\(self.originString)\(unit)"
    }
}
