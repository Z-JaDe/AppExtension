//
//  Price.swift
//  Extension
//
//  Created by ZJaDe on 2017/12/20.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//
// int float string
import Foundation
/** ZJaDe: 
 价格，默认输出保留2位小数的字符串，可通过valueFormatAutoUnit，valueFormat，originString自定义输出
    Price可以加减 但是Price本身不能小于0，所以值小的Price 减去 值大的Price会等于 0
 */
public struct Price: FloatLiteralTypeValueProtocol,
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
        self.value = value.double
        self.originString = value
    }
    // MARK: -
    public var positiveFormat = "#0.##"
    public func valueFormatAutoUnit(_ decimal: UInt?) -> (value: String, unit: String) {
        var result = (value: self.value, unit: "")
        if value >= 10000 {
            result = (value: value / 10000, unit: "万")
        }
        if let decimal = decimal {
            return (String(format: "%.\(decimal)f", result.value), result.unit)
        } else {
            decimalNumberFormat.positiveFormat = self.positiveFormat
            return (decimalNumberFormat.string(from: result.value as NSNumber) ??
                String(format: "%@", self.value as NSNumber), result.unit)
        }
    }
    public var descriptionWithUnit: String {
        let result = valueFormatAutoUnit(0)
        if result.unit.isEmpty == false {
            return "\(result.value)\(result.unit)"
        } else {
            return valueFormat(2)
        }
    }
    public var description: String {
        self.originString
    }
}
