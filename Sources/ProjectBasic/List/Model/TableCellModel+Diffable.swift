//
//  TableCellModel+Diffable.swift
//  AppExtension
//
//  Created by Apple on 2019/9/11.
//  Copyright © 2019 ZJaDe. All rights reserved.
//

import Foundation

extension AnyTableAdapterItem {
    public var cellModel: TableItemModel? {
        return self.value as? TableItemModel
    }
    public static func cellModel(_ value: TableItemModel) -> AnyTableAdapterItem {
        return AnyTableAdapterItem(value)
    }
}
extension TableCellModel: TableAdapterItemDiffable {
    public func isEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.cellModel else {
            return false
        }
        return self == source
    }
    public func isContentEqual(to source: AnyTableAdapterItem) -> Bool {
        guard let source = source.cellModel else {
            return false
        }
        return self.isContentEqual(to: source)
    }
}
