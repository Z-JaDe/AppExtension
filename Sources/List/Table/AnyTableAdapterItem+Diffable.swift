//
//  AnyTableAdapterItem+Diffable.swift
//  List
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

public protocol TableAdapterItemDiffable {
    func hash(into hasher: inout Hasher)
    func isEqual(to source: AnyTableAdapterItem) -> Bool
}

extension AnyTableAdapterItem: Hashable {
    public static func == (lhs: AnyTableAdapterItem, rhs: AnyTableAdapterItem) -> Bool {
        lhs.value.isEqual(to: rhs)
    }
    public func hash(into hasher: inout Hasher) {
        value.hash(into: &hasher)
    }
}
// MARK: - CustomStringConvertible
extension AnyTableAdapterItem: CustomStringConvertible {
    public var description: String {
        "\(type(of: self.value)):\(self.value)"
    }
}
