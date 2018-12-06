//
//  TimeStamp.swift
//  Extension
//
//  Created by 茶古电子商务 on 2017/12/20.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
/** ZJaDe: 
 一个时间戳
 */
public struct TimeStamp: FloatLiteralTypeValueProtocol,
    Codable,
    Comparable,
    ExpressibleValueProtocol,
    AddCalculatable,
    CustomStringConvertible, CustomDebugStringConvertible {

    public typealias ValueType = TimeInterval
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        if let value = value, value > 0 {
            self.value = value
        } else {
            self.value = 0
        }
    }

    public static func now() -> TimeStamp {
        return TimeStamp(Date().timeIntervalSince1970)
    }

    public func timeIntervalSinceNow() -> ValueType {
        return self.value - Date().timeIntervalSince1970
    }
    public func timeIntervalSince1970() -> ValueType {
        return self.value
    }
    static let dateFormatObject: DateFormatter = DateFormatter()
    public func dateFormat(_ dateFormat: String = "yyyy-mm-dd") -> String {
        TimeStamp.dateFormatObject.dateFormat = dateFormat
        return TimeStamp.dateFormatObject.string(from: Date(timeIntervalSince1970: self.value))
    }
    // MARK: -
    public var positiveFormat = "#0.#"
    public var description: String {
        return String(format: "%.0f", self.value)
    }
}
