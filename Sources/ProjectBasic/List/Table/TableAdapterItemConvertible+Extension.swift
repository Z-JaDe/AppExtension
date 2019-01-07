//
//  TableAdapterItemConvertible.swift
//  Alamofire
//
//  Created by 郑军铎 on 2018/7/17.
//

import Foundation
extension TableAdapterItemConvertible: AdapterItemType {
    public var cell: StaticTableItemCell? {
        return self.value as? StaticTableItemCell
    }
    public static func cell(_ value: StaticTableItemCell) -> TableAdapterItemConvertible {
        return TableAdapterItemConvertible(value)
    }
    public var model: TableItemModel? {
        return self.value as? TableItemModel
    }
    public static func model(_ value: TableItemModel) -> TableAdapterItemConvertible {
        return TableAdapterItemConvertible(value)
    }
    var tableItem: TableCellConfigProtocol & TableCellHeightProtocol & EnabledStateDesignable {
        // swiftlint:disable force_cast
        return self.value as! TableCellConfigProtocol & TableCellHeightProtocol & EnabledStateDesignable
    }
}
// MARK: - Diffable & Hashable
extension TableAdapterItemConvertible: Diffable, Hashable {
    public static func == (lhs: TableAdapterItemConvertible, rhs: TableAdapterItemConvertible) -> Bool {
        if let value1 = lhs.cell, let value2 = rhs.cell {
            return value1 == value2
        } else if let value1 = lhs.model, let value2 = rhs.model {
            return value1 == value2
        } else {
            assertionFailure("未知类型")
            return false
        }
    }
    public var hashValue: Int {
        if let value = self.cell {
            return value.hashValue
        } else if let value = self.model {
            return value.hashValue
        } else {
            assertionFailure("未知类型")
            return ObjectIdentifier(self.value).hashValue
        }
    }
    public func isContentEqual(to source: TableAdapterItemConvertible) -> Bool {
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
extension TableAdapterItemConvertible: CustomStringConvertible {
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
