//
//  JDString.swift
//  AppExtension
//
//  Created by Apple on 2019/10/16.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public struct JDString: StringLiteralTypeValueProtocol,
    Codable,
    ExpressibleValueProtocol,
    CustomStringConvertible, CustomDebugStringConvertible {

    public typealias ValueType = String
    public private(set) var value: ValueType
    public init(value: ValueType?) {
        self.value = value ?? ""
    }
}
