//
//  DecodingContainer.swift
//  Extension
//
//  Created by ZJaDe on 2017/12/27.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//

import Foundation
/** ZJaDe: 
 解析时先判断对应类型 不是对应类型的话 再判断其他。判断Int要放在Double前面
 */
public extension SingleValueDecodingContainer {
    func decodeInt() -> Int? {
        if decodeNil() {
            return nil
        } else if let value = try? decode(Int.self) {
            return value
        } else if let value = try? decode(String.self) {
            return value.toIntIfExist
        } else {
            return (try? decode(Double.self))?.toInt
        }
    }
    func decodeDouble() -> Double? {
        if decodeNil() {
            return nil
        } else if let value = try? decode(Double.self) {
            return value
        } else if let value = try? decode(String.self) {
            return value.toDoubleIfExist
        } else {
            return nil
        }
    }
    func decodeString() -> String? {
        if decodeNil() {
            return nil
        } else if let value = try? decode(String.self) {
            return value
        } else if let value = try? decode(Int.self) {
            return value.toString
        } else if let value = try? decode(Double.self) {
            return value.toString
        } else {
            return nil
        }
    }
    func decodeBool() -> Bool? {
        if decodeNil() {
            return nil
        } else if let value = try? decode(Bool.self) {
            return value
        } else if let value = try? decode(Int.self) {
            return value != 0
        } else if let value = try? decode(Double.self) {
            return value != 0
        } else {
            return (try? decode(String.self))?.toBool
        }
    }
}
