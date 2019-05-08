//
//  AnyTableAdapterItem.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/17.
//

import Foundation
extension AnyTableAdapterItem: AdapterItemType {
    public var cell: StaticTableItemCell? {
        return self.value as? StaticTableItemCell
    }
    public static func cell(_ value: StaticTableItemCell) -> AnyTableAdapterItem {
        return AnyTableAdapterItem(value)
    }
    public var model: TableItemModel? {
        return self.value as? TableItemModel
    }
    public static func model(_ value: TableItemModel) -> AnyTableAdapterItem {
        return AnyTableAdapterItem(value)
    }
}
// MARK: - Diffable & Hashable
extension AnyTableAdapterItem: Diffable, Hashable {
    public static func == (lhs: AnyTableAdapterItem, rhs: AnyTableAdapterItem) -> Bool {
        if let value1 = lhs.cell, let value2 = rhs.cell {
            return value1 == value2
        } else if let value1 = lhs.model, let value2 = rhs.model {
            return value1 == value2
        } else {
            assertionFailure("未知类型")
            return false
        }
    }
    public func hash(into hasher: inout Hasher) {
        if let value = self.cell {
            hasher.combine(value)
        } else if let value = self.model {
            hasher.combine(value)
        } else {
            assertionFailure("未知类型")
            hasher.combine(ObjectIdentifier(self.value))
        }
    }
    public func isContentEqual(to source: AnyTableAdapterItem) -> Bool {
        if let value1 = self.cell, let value2 = source.cell {
            return value1.isContentEqual(to: value2)
        } else if let value1 = self.model, let value2 = source.model {
            return value1.isContentEqual(to: value2)
        } else {
            assertionFailure("未知类型")
            return false
        }
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
