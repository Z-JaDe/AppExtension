//
//  MaxSelectedCount.swift
//  ProjectBasic
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public enum MaxSelectedCount {
    case noLimit
    case value(UInt)
}
extension MaxSelectedCount {
    var canSelected: Bool {
        switch self {
        case .noLimit: return true
        case .value(let count): return count > 0
        }
    }
    var count: UInt? {
        switch self {
        case .noLimit: return nil
        case .value(let count): return count
        }
    }
}
extension MaxSelectedCount: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .noLimit
    }
}
extension MaxSelectedCount: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: UInt) {
        self = .value(value)
    }
}
