//
//  StaticTableItemCell+Diffable.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension AnyTableAdapterItem {
    public var cell: StaticTableItemCell? {
        self.value as? StaticTableItemCell
    }
    public static func cell(_ value: StaticTableItemCell) -> AnyTableAdapterItem {
        AnyTableAdapterItem(value)
    }
}
extension StaticTableItemCell: TableAdapterItemDiffable {
    public func isEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.cell else {
            return false
        }
        return self == source
    }
    public func isContentEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.cell else {
            return false
        }
        return self.isContentEqual(to: source)
    }
}
extension StaticTableItemCell: Diffable {
    public func isContentEqual(to source: StaticTableItemCell) -> Bool {
        self.identity == source.identity
    }
    private var identity: String {
        "\(self.hashValue)\(self.needUpdateSentinel.value)"
    }
}
