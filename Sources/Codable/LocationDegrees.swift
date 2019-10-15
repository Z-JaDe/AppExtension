//
//  LocationDegrees.swift
//  Codable
//
//  Created by ZJaDe on 2018/1/17.
//  Copyright © 2018年 Z_JaDe. All rights reserved.
//

import Foundation
import CoreLocation
/** ZJaDe: 
 一个用于Codable的坐标
 */
public struct LocationDegrees: FloatLiteralTypeValueProtocol,
    Codable,
    Comparable,
    ExpressibleValueProtocol,
    Calculatable,
    CustomStringConvertible, CustomDebugStringConvertible {

    public typealias ValueType = CLLocationDegrees
    public private(set) var value: ValueType = 0
    public init(value: ValueType?) {
        self.value = value ?? 0
    }
    // MARK: -
    public var positiveFormat = "#0.0#"
}
