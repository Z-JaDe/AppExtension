//
//  TableAdapterItem+Hashable.swift
//  ProjectBasic
//
//  Created by 郑军铎 on 2020/3/15.
//  Copyright © 2020 ZJaDe. All rights reserved.
//

import Foundation
public struct AnyTableAdapterItem: ListAdapterItem, Hashable {
    public let value: Value
    public init(_ value: Value) {
        self.value = value
    }
}
// MARK: - Model
extension AnyTableAdapterItem {
    public var model: TableItemModel? {
        self.value as? TableItemModel
    }
    public static func model(_ value: TableItemModel) -> AnyTableAdapterItem {
        AnyTableAdapterItem(value)
    }
}
extension TableItemModel: ListAdapterItemHashable {
    public func isEqual(to source: ListAdapterItem) -> Bool {
        guard let source = (source as? AnyTableAdapterItem)?.model else {
            return false
        }
        return self == source
    }
}
// MARK: - Cell
extension AnyTableAdapterItem {
    public var cell: StaticTableItemCell? {
        self.value as? StaticTableItemCell
    }
    public static func cell(_ value: StaticTableItemCell) -> AnyTableAdapterItem {
        AnyTableAdapterItem(value)
    }
}
extension StaticTableItemCell: ListAdapterItemHashable {
    public func isEqual(to source: ListAdapterItem) -> Bool {
        guard let source = (source as? AnyTableAdapterItem)?.cell else {
            return false
        }
        return self == source
    }
}
// MARK: -
extension AnyTableAdapterItem {
    public var cellModel: TableItemModel? {
        self.value as? TableItemModel
    }
    public static func cellModel(_ value: TableItemModel) -> AnyTableAdapterItem {
        AnyTableAdapterItem(value)
    }
}
extension TableCellModel: ListAdapterItemHashable {
    public func isEqual(to source: ListAdapterItem) -> Bool {
        guard let source = (source as? AnyTableAdapterItem)?.cellModel else {
            return false
        }
        return self == source
    }
}
