//
//  Count.swift
//  Extension
//
//  Created by 茶古电子商务 on 2017/12/7.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//
// int float string
import Foundation
/** ZJaDe: 
 一个数字，可为负数，Codable时可用到
 */
public struct Number: IntegerLiteralTypeValueProtocol,
    Codable,
    Comparable,
    ExpressibleValueProtocol,
    Calculatable,
    CustomStringConvertible, CustomDebugStringConvertible {

    public typealias ValueType = Int
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        self.value = value ?? 0
    }
}
