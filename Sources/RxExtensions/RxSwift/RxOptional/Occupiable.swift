//
//  Occupiable.swift
//  JDKit
//
//  Created by ZJaDe on 2017/11/23.
//  Copyright © 2017年 Z_JaDe. All rights reserved.
//
import RxOptional
public extension Occupiable {
    var nilIfEmpty: Self? {
        self.isEmpty
            ? .none
            : .some(self)
    }
}

extension Optional where Wrapped: Occupiable {
    public var isNilOrEmpty: Bool {
        switch self {
        case .none:
            return true
        case .some(let value):
            return value.isEmpty
        }
    }
    public var isNotNilNotEmpty: Bool {
        !isNilOrEmpty
    }
}
