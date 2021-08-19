//
//  Price.swift
//  Codable
//
//  Created by 郑军铎 on 2021/7/20.
//  Copyright © 2021 ZJaDe. All rights reserved.
//

import Foundation

/** ZJaDe:
 价格，默认输出保留2位小数的字符串，可通过valueFormatAutoUnit，valueFormat，originString自定义输出
    Price可以加减 但是Price本身不能小于0，所以值小的Price 减去 值大的Price会等于 0
 */
struct Price: Codable {
    typealias ValueType = FloatLiteralType
    private(set) var stringValue: String = ""
    private(set) var floatValue: ValueType
    init(value: ValueType?) {
        self.floatValue = value.map({ max($0, 0) }) ?? 0
        self.stringValue = valueFormat(2)
    }
    init(stringLiteral value: String) {
        self.floatValue = Double(value) ?? 0
        self.stringValue = value
    }
}
extension Price: Comparable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.floatValue == rhs.floatValue
    }
    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.floatValue < rhs.floatValue
    }
}
extension Price: CustomStringConvertible, CustomDebugStringConvertible {
    var debugDescription: String {
        stringValue
    }
    var description: String {
        stringValue
    }
    var descriptionWithUnit: String {
        let result = valueFormatAutoUnit(0)
        if result.unit.isEmpty == false {
            return "\(result.value)\(result.unit)"
        } else {
            return valueFormat(2)
        }
    }
}

// MARK: -
private let numberFormat: NumberFormatter = {
    let format = NumberFormatter()
    format.numberStyle = .decimal
    format.positiveFormat = "#0.##"
    return format
}()
extension Price {
    /// decimal: 保留几位小数, nil保留有效位数, 传整数为保留几位小数
    func valueFormat(_ decimal: UInt?) -> String {
        if let decimal = decimal {
            return String(format: "%.\(decimal)f", self.floatValue)
        } else {
            return numberFormat.string(from: self.floatValue as NSNumber) ??
                String(format: "%@", self.floatValue as NSNumber)
        }
    }
    func valueFormatAutoUnit(_ decimal: UInt?) -> (value: String, unit: String) {
        var result = (value: self.floatValue, unit: "")
        if floatValue >= 10000 {
            result = (value: floatValue / 10000, unit: "万")
        }
        if let decimal = decimal {
            return (String(format: "%.\(decimal)f", result.value), result.unit)
        } else {
            return (numberFormat.string(from: result.value as NSNumber) ??
                String(format: "%@", self.floatValue as NSNumber), result.unit)
        }
    }
}
