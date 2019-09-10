//
//  AnyTableAdapterItem.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/17.
//

import Foundation

public protocol TableAdapterItemDiffable {
    func hash(into hasher: inout Hasher)
    func isEqual(to source: AnyTableAdapterItem) -> Bool
    func isContentEqual(to source: AnyTableAdapterItem) -> Bool
}

// MARK: - Diffable & Hashable
extension AnyTableAdapterItem: Diffable, Hashable {
    public static func == (lhs: AnyTableAdapterItem, rhs: AnyTableAdapterItem) -> Bool {
        guard let lhs = lhs.value as? TableAdapterItemDiffable else {
            assertionFailure("未知类型")
            return false
        }
        return lhs.isEqual(to: rhs)
    }
    public func hash(into hasher: inout Hasher) {
        guard let value = self.value as? TableAdapterItemDiffable else {
            assertionFailure("未知类型")
            hasher.combine(ObjectIdentifier(self.value))
            return
        }
        value.hash(into: &hasher)
    }
    public func isContentEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let value = self.value as? TableAdapterItemDiffable else {
            assertionFailure("未知类型")
            return false
        }
        return value.isContentEqual(to: source)
    }
}
// MARK: - CustomStringConvertible
extension AnyTableAdapterItem: CustomStringConvertible {
    public var description: String {
        if let value = self.cell {
            return "cell: \(value)"
        } else if let value = self.model {
            return "model: \(value)"
        } else {
            assertionFailure("未知类型")
            return "\(self.value)"
        }
    }
}
