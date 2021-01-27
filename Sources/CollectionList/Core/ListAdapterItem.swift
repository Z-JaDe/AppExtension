//
//  AnyTableAdapterItem.swift
//  ProjectBasic
//
//  Created by ZJaDe on 2019/1/4.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol AdapterItemCompatible {
    var realItem: Any {get}
}
extension AdapterItemCompatible {
    public var realItem: Any {
        self
    }
}
// MARK: -
public protocol ListAdapterItemHashable {
    func hash(into hasher: inout Hasher)
    func isEqual(to source: ListAdapterItem) -> Bool
}
public protocol ListAdapterItem: AdapterItemCompatible, CustomStringConvertible {
    typealias Value = AnyObject & ListAdapterItemHashable
    var value: Value { get }
}

// MARK: -
extension ListAdapterItem where Self: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value.isEqual(to: rhs)
    }
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}
// MARK: - CustomStringConvertible
extension ListAdapterItem {
    public var description: String {
        "\(type(of: self.value)):\(self.value)"
    }
}
