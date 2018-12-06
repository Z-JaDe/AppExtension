//
//  Score.swift
//  Codable
//
//  Created by 茶古电子商务 on 2018/1/10.
//  Copyright © 2018年 Z_JaDe. All rights reserved.
//

import Foundation
/** ZJaDe: 
 表示分数 星星评分时可以用
 */
public struct Score: FloatLiteralTypeValueProtocol,
    Codable,
    Comparable,
    ExpressibleValueProtocol,
    CustomStringConvertible, CustomDebugStringConvertible {

    public typealias ValueType = FloatLiteralType
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        if let value = value, value > 0 {
            self.value = value
        } else {
            self.value = 0
        }
    }
    // MARK: -
    public var positiveFormat = "#0.#"
    public var description: String {
        return String(format: "%.1f分", self.value)
    }
}
