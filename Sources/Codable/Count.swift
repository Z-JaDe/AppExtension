//
//  Count.swift
//  Extension
//
//  Created by 茶古电子商务 on 2017/12/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
/** ZJaDe: 
 表示数量
 */
public struct Count: IntegerLiteralTypeValueProtocol,
    Codable,
    Comparable,
    ExpressibleValueProtocol,
    AddCalculatable,
    CustomStringConvertible, CustomDebugStringConvertible {
    public typealias ValueType = Int
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        if let value = value, value > 0 {
            self.value = value
        } else {
            self.value = 0
        }
    }
}
